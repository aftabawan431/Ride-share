import 'dart:convert';
import 'dart:typed_data';
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../../../core/utils/constants/socket_point.dart';
import '../../../../core/utils/encryption/encryption.dart';
import '../../../../core/widgets/modals/confirm_ride_modal.dart';
import '../../../dashboard/presentation/providers/rating_provider.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../data/models/active_passenger_ride_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsKit;

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/router/pages.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/location/dashboard_helper.dart';
import '../../../../core/utils/location/location_api.dart';
import '../../../../core/utils/sockets/sockets.dart';

class PassengerRideProvider extends ChangeNotifier {
  BuildContext? homeContext;
  bool showLiveLocations = false;
  //properties
  GoogleMapController? googleMapController;
  Position? currentDriverPosition;
  Position? oldPosition;

  bool isInScreen = false;

  ActivePassengerRideModel? currentRide;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  DashBoardHelper dashBoardHelper = sl();

//getters
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  //sockets
  getAndSetCurrentRide({required String routeId, required String scheduleId}) {
    if (isInScreen) {
      return;
    }
    final data = {"routeId": routeId, "scheduleId": scheduleId};
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    Loading.show(message: 'Getting ride info');

    SocketService.socket!.emitWithAck(
        SocketPoint.passengerActiveRideEmitter, jsonEncode(encryptedParams),
        ack: (data) {
      final decryptedResponse = Encryption.decryptJson(data);
      currentRide = ActivePassengerRideModel.fromJson(decryptedResponse);

      Loading.dismiss();

      goToNext(PageConfigs.passengerRideScreenPageConfig);
    });
  }

  updateActiveRideStatusListener() {

    SocketService.on(SocketPoint.updatePassengerRideStatus,
        (data) async {

      final decryptedResponse = Encryption.decryptJson(jsonDecode(data));
      final status = decryptedResponse['status'];

      currentRide!.status = status;
      Logger().v(currentRide!.status);
      if (status == 'completed') {
        DashboardProvider dashboardProvider=sl();
        dashboardProvider.getDashboardData(showLoading: false);
        await ClearAllNotifications.clear();

        RatingProvider ratingProvider = sl();
        ratingProvider.fullName =
            "${currentRide!.data.route.userId.firstName} ${currentRide!.data.route.userId.lastName}";
        ratingProvider.scheduleId = currentRide!.data.schedule.id;
        ratingProvider.ratingTo = currentRide!.data.schedule.userId.id;
        ratingProvider.routeId = currentRide!.data.route.id;
        ratingProvider.profileImage =
            currentRide!.data.route.userId.profileImage;
        ratingProvider.historyId = null;
        ScheduleProvider provider = sl();
        provider.getPassengerSchedules(recall: true);
        if (isInScreen) {
          ratingProvider.popTwice = true;
          AppState appState = sl();
          appState.currentAction = PageAction(
            state: PageState.addPage,
            page: PageConfigs.ratingPageConfig,
          );
        } else {
          ratingProvider.popTwice = false;
          AppState appState = sl();
          appState.currentAction = PageAction(
            state: PageState.addPage,
            page: PageConfigs.ratingPageConfig,
          );
        }
      } else if (status == 'cancelled') {
        if (isInScreen) {
          ScheduleProvider provider = sl();
          provider.getPassengerSchedules(recall: true);
          AppState appState = sl();
          appState.moveToBackScreen();
        }
      } else if (status == 'arrived') {
        currentRide!.verifyPin = decryptedResponse['verifyPin'];
        ConfirmRideModal confirmRideModel = ConfirmRideModal(homeContext!);
        confirmRideModel.show();
      }
      notifyListeners();
    });
  }

  confirmRide() {
    SocketService.socket!.emit(
        SocketPoint.confirmStartRide,
        jsonEncode(Encryption.encryptObject(jsonEncode({
          "routeId": currentRide!.data.route.id,
          "passengerId": currentRide!.data.schedule.id
        }))));
  }

  updateActiveRIdeStatusListnerOff() {
    SocketService.socket!.off(SocketPoint.updatePassengerRideStatus);
  }

  //sockets

  listenDriverLocationUpdates() {
    SocketService.on(SocketPoint.driverLocationUpdatesOn, (data) async {
      if (showLiveLocations == false) {
        return;
      }
      final data2 = Encryption.decryptJson(jsonDecode(data));

      DashBoardHelper dashBoardHelper = sl();
      currentDriverPosition = Position(
          longitude: double.parse(data2['longitude'].toString()),
          latitude: double.parse(data2['latitude'].toString()),
          timestamp: null,
          accuracy: 1,
          altitude: 1,
          heading: 1,
          speed: 1,
          speedAccuracy: 1);

      Uint8List customMarker =
          await dashBoardHelper.makeCustomMarker(AppAssets.cabPng, width: 40);
      var rotation = mapsKit.SphericalUtil.computeHeading(
          mapsKit.LatLng(oldPosition!.latitude, oldPosition!.longitude),
          mapsKit.LatLng(currentDriverPosition!.latitude,
              currentDriverPosition!.longitude));
      markers.removeWhere((element) => element.markerId.value == 'driver');

      addMarker(
        Marker(
          zIndex: 10,
          markerId: const MarkerId('driver'),
          icon: BitmapDescriptor.fromBytes(customMarker),
          anchor: const Offset(0.5, 0.5),
          rotation: rotation.toDouble(),
          position: LatLng(
            currentDriverPosition!.latitude,
            currentDriverPosition!.longitude,
          ),
        ),
      );
      oldPosition = currentDriverPosition;
    });
  }

  //maps
  void onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    listenDriverLocationUpdates();
    setCurrentPosition();
    await setDriverInitialPosition();
    drawPolylines();

    SocketService.socket!.off(SocketPoint.updatePassengerRideStatus);
    updateActiveRideStatusListener();
    // setCurrentUserLocationStream();
  }

  void drawPolylines() async {
    addMarker(
      Marker(
          markerId: const MarkerId('end-location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          // anchor: Offset(0.5, 0.5),
          position: LatLng(
            double.parse(currentRide!.data.schedule.endPoint.latitude),
            double.parse(currentRide!.data.schedule.endPoint.longitude),
          ),
          infoWindow:
              InfoWindow(title: currentRide!.data.schedule.endPoint.placeName)),
    );
    Uint8List starMarket =
        await dashBoardHelper.makeCustomMarker(AppAssets.fromSvg, width: 70);
    addMarker(
      Marker(
          markerId: const MarkerId('start-location'),
          icon: BitmapDescriptor.fromBytes(starMarket),
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            double.parse(currentRide!.data.schedule.startPoint.latitude),
            double.parse(currentRide!.data.schedule.startPoint.longitude),
          ),
          infoWindow: InfoWindow(
              title: currentRide!.data.schedule.startPoint.placeName,
              snippet: "This is snippet"),
          onTap: () {
            Logger().v('Go to that point');
          }),
    );
    addPolyline(Polyline(
        polylineId: const PolylineId(
          'schedule',
        ),
        points: PolylinePoints()
            .decodePolyline(currentRide!.data.schedule.polyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
        color: Colors.purple,
        width: 3));

    googleMapController!.animateCamera((CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(
              currentRide!.data.schedule.boundsSw.latitude,
              currentRide!.data.schedule.boundsSw.longitude,
            ),
            northeast: LatLng(
              currentRide!.data.schedule.boundsNe.latitude,
              currentRide!.data.schedule.boundsNe.longitude,
            )),
        50)));
  }

  newMessageReceivedCountListener() {
    SocketService.on(SocketPoint.newMessageListner, (data) {
      Logger().v(data);
      final decoded = jsonDecode(data);
      final userId = decoded['userId'];
      final count = decoded['count'];
      currentRide!.count = count;
      notifyListeners();
    });
  }

  setNewMessageCountToZero() {
    currentRide!.count = 0;
    notifyListeners();
  }

  newMessageReceivedCountListenerOff() {
    SocketService.socket!.off(SocketPoint.newMessageListner);
  }

  addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  addPolyline(Polyline value) {
    _polylines.add(value);
    notifyListeners();
  }

  setCurrentPosition() async {
    try {
      final position = await LocationApi.determinePosition();
      currentDriverPosition = position;

      googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentDriverPosition!.latitude,
                  currentDriverPosition!.longitude),
              zoom: 17)));
      notifyListeners();
    } catch (e) {
      ShowSnackBar.show(e.toString());
    }
  }

  setDriverInitialPosition() async {
    DashBoardHelper dashBoardHelper = sl();
    final lastLocation = currentRide!.data.route.lastLocation;
    Uint8List customMarker =
        await dashBoardHelper.makeCustomMarker(AppAssets.cabPng, width: 40);
    var rotation = mapsKit.SphericalUtil.computeHeading(
        mapsKit.LatLng(lastLocation.latitude, lastLocation.longitude),
        mapsKit.LatLng(lastLocation.latitude, lastLocation.longitude));
    currentDriverPosition = Position(
        longitude: lastLocation.longitude,
        latitude: lastLocation.latitude,
        timestamp: null,
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1);

    oldPosition = Position(
        longitude: lastLocation.longitude,
        latitude: lastLocation.latitude,
        timestamp: null,
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1);

    addMarker(
      Marker(
        zIndex: 10,
        markerId: const MarkerId('driver'),
        icon: BitmapDescriptor.fromBytes(customMarker),
        anchor: const Offset(0.5, 0.5),
        rotation: rotation.toDouble(),
        position: LatLng(
          currentRide!.data.route.lastLocation.latitude,
          currentRide!.data.route.lastLocation.longitude,
        ),
      ),
    );
  }

  //navigation
  goToNext(PageConfiguration pageConfigs) {
    AppState appState = sl();
    appState.currentAction = PageAction(
      state: PageState.addPage,
      page: pageConfigs,
    );
  }
}

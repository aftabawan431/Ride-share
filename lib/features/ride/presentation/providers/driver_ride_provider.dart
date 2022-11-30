import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rideshare/core/utils/network/network_info.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/utils/constants/socket_point.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/sockets/sockets.dart';
import '../../../../core/widgets/modals/finish_ride_modal.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../drawer_wrapper/schedules_driver/data/models/get_requested_passenger_response_model.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../data/models/active_ride_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsKit;

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/pages.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/encryption/encryption.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/location/dashboard_helper.dart';
import '../../../../core/utils/location/location_api.dart';

class DriverRideProvider extends ChangeNotifier {
  late ActiveDriverRideModel currentRide;

  //properties

  List<RequestedPassengerRequest> inrideRequests = [];
  GoogleMapController? googleMapController;

  int selectedPassengerIndex = 0;

  bool isInDriverRideScreen = false;

  Position? currentPosition;
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Position? oldPosition;
  StreamSubscription<Position>? positionStream;

  DashBoardHelper dashBoardHelper;
  DriverRideProvider(this.dashBoardHelper);

  //getters
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  //sockets
  getAndSetCurrentRide(String routeId,
      {PageState pageState = PageState.addPage}) {
    Logger().v(routeId);
    Loading.show(message: 'Getting ride info');
    AuthProvider authProvider = sl();
    final encryptedParams = Encryption.encryptObject(jsonEncode(
        {"routeId": routeId, "userId": authProvider.currentUser!.id}));
    SocketService.socket!.emitWithAck(
        SocketPoint.startContinueRideByDriver, jsonEncode(encryptedParams),
        ack: (data) {

      Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);
      // Logger().v(data);
      Logger().v(decryptedResponse);

      currentRide =
          ActiveDriverRideModel.fromJson(decryptedResponse['activeRide']);
      currentRide.passengers
          .sort((a, b) => a.sortDistance.compareTo(b.sortDistance));
      inrideRequests = decryptedResponse['pendingList']
          .map<RequestedPassengerRequest>(
              (e) => RequestedPassengerRequest.fromJson(e))
          .toList();

      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);
      goToNext(PageConfigs.driverRideScreenPageConfig, pageState: pageState);
    });
  }

  confirmationByPassengerListener() async {
    Logger().v("Started listening");
    SocketService.on(SocketPoint.rideConfirmationByPassengerListener,
        (data) {
      Logger().v("Confirmation");
      Logger().v(data);
      final decryptedResponse = Encryption.decryptJson(jsonDecode(data));
      currentRide = ActiveDriverRideModel.fromJson(decryptedResponse);
      notifyListeners();
    });
  }
  confirmationByPassengerListenerOff()async{
    SocketService.socket!.off(SocketPoint.rideConfirmationByPassengerListener);

  }

  removeInrideRequestFromList(String id) {
    inrideRequests.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  //inride requests

  //passenger ride cacellation listener

  passengerRideCancellationListener() {
    SocketService.on(SocketPoint.passengerRideCancellationListner,
        (data) {
      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);
      if (!isInDriverRideScreen) {
        return;
      }
      final decryptedResponse = Encryption.decryptJson(jsonDecode(data));
      final passengerId = decryptedResponse['passengerId'];
      bool exist = currentRide.passengers
          .where((element) => element.passenger.id == passengerId)
          .toList()
          .isNotEmpty;
      if (exist) {
        final passenger = currentRide.passengers
            .firstWhere((element) => element.passenger.id == passengerId);
        passenger.status = 'cancelled';
        notifyListeners();
      }
    });
  }

  passengerRideCancellationListenerOff() {
    SocketService.off('passengerRideCancellationListener');
  }

  setCountToZero(String userId) {
    final index = currentRide.passengers
        .indexWhere((element) => element.passenger.userId.id == userId);
    currentRide.passengers[index].count = 0;
    notifyListeners();
  }

  newMessageReceivedCountListener() {
    SocketService.on(SocketPoint.newMessageListner, (data) {
      final decoded = jsonDecode(data);
      final userId = decoded['sender'];
      final count = decoded['count'];
      Logger().v(userId);
      final index = currentRide.passengers
          .indexWhere((element) => element.passenger.userId.id == userId);
      if (index > -1) {
        currentRide.passengers[index].count = count;
        notifyListeners();
      }
    });
  }

  newMessageReceivedCountListenerOff() {
    SocketService.socket!.off(SocketPoint.newMessageListner);
  }

  //reject inride request
  rejectInRideRequest(String scheduleId) {
    final data = {
      "scheduleId": scheduleId,
      "routeId": currentRide.routeId.id,
    };

    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    inrideRequests.removeWhere((element) => element.id == scheduleId);
    notifyListeners();
    final encodeData = jsonEncode(encryptedParams);
    SocketService.socket!.emitWithAck(
        SocketPoint.rejectInRideRequestEmit, encodeData,
        ack: (data) {});
  }

  //accept inride request
  acceptInRideRequest(String scheduleId) {
    final data = {
      "scheduleId": scheduleId,
      "routeId": currentRide.routeId.id,
      "rideId": currentRide.id
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    Loading.show(message: 'Accepting');
    SocketService.socket!.emitWithAck(
        SocketPoint.acceptInRideRequestEmit, jsonEncode(encryptedParams),
        ack: (data) async {
      Logger().v(data);
      Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);

      inrideRequests.removeWhere((element) => element.id == scheduleId);
      final passenger = Passengers.fromJson(decryptedResponse['data']);
      currentRide.passengers.add(passenger);
      currentRide.passengers
          .sort((a, b) => a.sortDistance.compareTo(b.sortDistance));
      if (currentRide.passengers.length == 1) {
        selectedPassengerIndex = 0;
        await addSelectedPassengerLine();
      }

      final icon = await getMarkerImageFromUrl(
          AppUrl.fileBaseUrl + passenger.passenger.userId.profileImage,
          targetWidth: 80);
      addMarker(Marker(
          markerId: MarkerId(passenger.passenger.id),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            double.parse(passenger.passenger.startPoint.latitude),
            double.parse(passenger.passenger.startPoint.longitude),
          ),
          infoWindow: InfoWindow(
            title: passenger.passenger.startPoint.placeName,
          ),
          onTap: () {
            Logger().v('Go to that point');
          }));
      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);
      notifyListeners();
    });
  }

  inRideNewRequestListnerOn() {
    Logger().v('Started listening new ride updates');
    SocketService.on(SocketPoint.inRideRequestListener, (data) {
      Logger().v("Req is comming to this listener");
      Logger().v(data);
      final decryptedResponse = Encryption.decryptJson(jsonDecode(data));

      final passegner =
          RequestedPassengerRequest.fromJson(decryptedResponse['data']);
      inrideRequests.add(passegner);
      notifyListeners();
    });
  }

  inRideNewRequestListnerOff() {
    SocketService.socket!.off(SocketPoint.inRideRequestListener);
  }

  driverOnTheWay({required String scheduleId}) {
    // Loading.show(message: 'Requesting');
    final encryptedParams = Encryption.encryptObject(
        jsonEncode({"passengerId": scheduleId, "rideId": currentRide.id}));

    SocketService.socket!.emitWithAck(
        SocketPoint.onTheWayEmitter, jsonEncode(encryptedParams), ack: (data) {
      Logger().v(data);
      // Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);
      currentRide = ActiveDriverRideModel.fromJson(decryptedResponse);
      notifyListeners();
    });
  }

  cancelInRidePassengerRequestByDriver(String passengerId,String reason) {
    final data = {"passengerId": passengerId, "rideId": currentRide.id,"reason":reason};
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    final encoded = jsonEncode(encryptedParams);

    SocketService.socket!.emitWithAck(
        SocketPoint.cancelInRidePassengerRequestByDriver, encoded, ack: (data) {
          Loading.dismiss();
      final decryptedParams = Encryption.decryptJson(data);
      Logger().v(decryptedParams);


      if (decryptedParams['finish'] == true) {
        FinishRideModal finishRideModal = FinishRideModal(navigatorKeyGlobal.currentContext!);
        finishRideModal.show();
      }


      currentRide.passengers
          .removeWhere((element) => element.passenger.id == passengerId);
      _markers.removeWhere((element) =>
          element.markerId.value == passengerId ||
          element.markerId.value == 'passengerdmarker');
      polylines.removeWhere(
          (element) => element.polylineId.value == 'passengerLine');
      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);

      notifyListeners();
    });
  }

  driverArrived({required String scheduleId}) {
    Loading.show(message: 'Requesting');
    final encryptedParams = Encryption.encryptObject(
        jsonEncode({"passengerId": scheduleId, "rideId": currentRide.id}));

    SocketService.socket!.emitWithAck(
        SocketPoint.arrivedEmitter, jsonEncode(encryptedParams), ack: (data) {
      Logger().v(data);
      Loading.dismiss();
      final decryptedParams = Encryption.decryptJson(data);
      currentRide = ActiveDriverRideModel.fromJson(decryptedParams);
      notifyListeners();
    });
  }

  startRide({required String scheduleId}) {
    // Loading.show(message: 'Requesting');
    final encryptedParams = Encryption.encryptObject(
        jsonEncode({"passengerId": scheduleId, "rideId": currentRide.id}));

    SocketService.socket!.emitWithAck(
        SocketPoint.startRideEmitter, jsonEncode(encryptedParams), ack: (data) {
      final decryptedParams = Encryption.decryptJson(data);

      Logger().v(data);
      // Loading.dismiss();
      currentRide = ActiveDriverRideModel.fromJson(decryptedParams);
      notifyListeners();
    });
  }

  completeRide(BuildContext context, {required String scheduleId,required String otp}) async {
    // Loading.show(message: 'Requesting');
    AppState appState=sl();
    final encryptedParams = Encryption.encryptObject(
        jsonEncode({"passengerId": scheduleId, "rideId": currentRide.id,"otp":otp}));
    NetworkInfo networkInfo = sl();
    if (await networkInfo.isConnected) {
      SocketService.socket!.emitWithAck(
          SocketPoint.completeRideEmitter, jsonEncode(encryptedParams),
          ack: (data) {
        // Loading.dismiss();
        Logger().v(data);
        final decryptedParams = Encryption.decryptJson(data);

        currentRide = ActiveDriverRideModel.fromJson(decryptedParams['ride']);

        Logger().v(decryptedParams);

        if (decryptedParams['finish'] == true) {
          FinishRideModal finishRideModal = FinishRideModal(navigatorKeyGlobal.currentContext!);
          finishRideModal.show();
        }

        notifyListeners();
        appState.moveToBackScreen();
      });
    } else {
      final index = currentRide.passengers
          .indexWhere((element) => element.passenger.id == scheduleId);
      currentRide.passengers[index].status = 'completed';
      Logger().v(currentRide.passengers[index].status);
      Logger().v('it is completed');
      notifyListeners();
      FlutterSecureStorage secureStorage = sl();
      final pendingRides = await secureStorage.read(key: 'pendingRides');
      final data = {
        "passengerId": scheduleId,
        "rideId": currentRide.id,
        "status": "completed"
      };
      if (pendingRides != null) {
        final decodedRides = jsonDecode(pendingRides);
        decodedRides.add(data);
        final encoded = jsonEncode(decodedRides);
        await secureStorage.write(key: 'pendingRides', value: encoded);
      } else {
        final encoded = jsonEncode([data]);
        await secureStorage.write(key: 'pendingRides', value: encoded);
      }
      notifyListeners();
      appState.moveToBackScreen();
    }
  }

  //maps

  void onMapCreated(GoogleMapController controller) async {
    markers.clear();
    polylines.clear();

    googleMapController = controller;
    await setCurrentPosition();
    // await getLocationsUpdates();
    showPassengersMarkers();
    addRoutePolyline();
    addSelectedPassengerLine();
    // setCurrentUserLocationStream();
  }

  showPassengersMarkers() {
    currentRide.passengers.forEach((element) async {
      final icon = await getMarkerImageFromUrl(
          AppUrl.fileBaseUrl + element.passenger.userId.profileImage,
          targetWidth: 80);
      addMarker(Marker(
          markerId: MarkerId(element.passenger.id),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            double.parse(element.passenger.startPoint.latitude),
            double.parse(element.passenger.startPoint.longitude),
          ),
          infoWindow: InfoWindow(
            title: element.passenger.startPoint.placeName,
          ),
          onTap: () {
            Logger().v('Go to that point');
          }));
      //destination marker
    });
  }

  addSelectedPassengerLine() {
    if (currentRide.passengers.isEmpty) {
      return;
    }
    addMarker(Marker(
        markerId: const MarkerId('passengerdmarker'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(
          double.parse(currentRide
              .passengers[selectedPassengerIndex].passenger.endPoint.latitude),
          double.parse(currentRide
              .passengers[selectedPassengerIndex].passenger.endPoint.longitude),
        ),
        infoWindow: InfoWindow(
          title: currentRide
              .passengers[selectedPassengerIndex].passenger.endPoint.placeName,
        ),
        onTap: () {
          Logger().v('Go to that point');
        }));
    addPolyline(Polyline(
        polylineId: const PolylineId('passengerLine'),
        zIndex: 10,
        points: PolylinePoints()
            .decodePolyline(currentRide
                .passengers[selectedPassengerIndex].passenger.encodedPolyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
        color: Colors.red,
        width: 3));
  }

  // customize user netowork iamge as marker
  Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    required int targetWidth,
  }) async {
    assert(url != null);
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    if (targetWidth != null) {
      return convertImageFileToBitmapDescriptor(markerImageFile,
          size: targetWidth);
    } else {
      Uint8List markerImageBytes = await markerImageFile.readAsBytes();
      return BitmapDescriptor.fromBytes(markerImageBytes);
    }
  }

  Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(File imageFile,
      {int size = 100,
      bool addBorder = false,
      Color borderColor = Colors.white,
      double borderSize = 100,
      Color titleColor = Colors.transparent,
      Color titleBackgroundColor = Colors.transparent}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        const Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(size / 2.toDouble(), size + 20.toDouble(), 10, 10),
        const Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  addRoutePolyline() async {
    addMarker(
      Marker(
          markerId: const MarkerId('end-location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          // anchor: Offset(0.5, 0.5),
          position: LatLng(
            double.parse(currentRide.routeId.endPoint.latitude),
            double.parse(currentRide.routeId.endPoint.longitude),
          ),
          infoWindow:
              InfoWindow(title: currentRide.routeId.endPoint.placeName)),
    );

    Uint8List starMarket =
        await dashBoardHelper.makeCustomMarker(AppAssets.fromSvg, width: 70);
    addMarker(
      Marker(
          markerId: const MarkerId('start-location'),
          icon: BitmapDescriptor.fromBytes(starMarket),
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            double.parse(currentRide.routeId.startPoint.latitude),
            double.parse(currentRide.routeId.startPoint.longitude),
          ),
          infoWindow: InfoWindow(
            title: currentRide.routeId.startPoint.placeName,
          ),
          onTap: () {
            Logger().v('Go to that point');
          }),
    );
    _polylines.removeWhere(
        (element) => element.polylineId.value == currentRide.routeId.id);
    addPolyline(Polyline(
        polylineId: PolylineId(
          DateTime.now().toString(),
        ),
        points: PolylinePoints()
            .decodePolyline(currentRide.routeId.encodedPolyline)
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
        color: Colors.purple,
        width: 3));
    googleMapController!.animateCamera((CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(currentRide.routeId.boundsSw.latitude,
                currentRide.routeId.boundsSw.longitude),
            northeast: LatLng(currentRide.routeId.boundsNe.latitude,
                currentRide.routeId.boundsNe.longitude)),
        50)));
  }

  setCurrentPosition() async {
    try {
      final position = await LocationApi.determinePosition();
      currentPosition = position;
      oldPosition = position;
      googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(currentPosition!.latitude, currentPosition!.longitude),
              zoom: 17)));
      notifyListeners();
    } catch (e) {
      ShowSnackBar.show(e.toString());
    }
  }

  setSelectedPassengerIndex(int value) {
    selectedPassengerIndex = value;
    notifyListeners();
  }

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 0,
  );

  updateDriverLocation(Position position) async {
    if (position == null) {
      return;
    }
    if (oldPosition == null) {
      oldPosition = position;
    }
    Uint8List customMarker =
        await dashBoardHelper.makeCustomMarker(AppAssets.cabPng, width: 40);
    var rotation = mapsKit.SphericalUtil.computeHeading(
        mapsKit.LatLng(oldPosition!.latitude, oldPosition!.longitude),
        mapsKit.LatLng(position.latitude, position.longitude));
    markers.removeWhere((element) => element.markerId.value == 'current');
    addMarker(
      Marker(
        zIndex: 10,
        markerId: const MarkerId('current'),
        icon: BitmapDescriptor.fromBytes(customMarker),
        anchor: const Offset(0.5, 0.5),
        rotation: rotation.toDouble(),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
      ),
    );

    oldPosition = position;
    notifyListeners();
  }

  getLocationsUpdates() {
    if (positionStream != null) {
      return;
    }
    if (googleMapController == null) {
      return;
    }

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      if (position == null) {
        return;
      }
      Uint8List customMarker =
          await dashBoardHelper.makeCustomMarker(AppAssets.cabPng, width: 40);
      var rotation = mapsKit.SphericalUtil.computeHeading(
          mapsKit.LatLng(oldPosition!.latitude, oldPosition!.longitude),
          mapsKit.LatLng(position.latitude, position.longitude));
      markers.removeWhere((element) => element.markerId.value == 'current');
      addMarker(
        Marker(
          zIndex: 10,
          markerId: const MarkerId('current'),
          icon: BitmapDescriptor.fromBytes(customMarker),
          anchor: const Offset(0.5, 0.5),
          rotation: rotation.toDouble(),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
        ),
      );
      SocketService.socket!.emit(
          SocketPoint.updateDriverLocatin,
          jsonEncode({
            "routeId": currentRide.routeId.id,
            "location": {
              "latitude": position.latitude,
              "longitude": position.longitude
            }
          }));
      oldPosition = position;
      notifyListeners();
    });
  }

  addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  addPolyline(Polyline value) {
    _polylines.add(value);
    notifyListeners();
  }

//navigation
  goToNext(PageConfiguration pageConfigs,
      {PageState pageState = PageState.addPage}) {
    AppState appState = sl();
    appState.currentAction = PageAction(
      state: pageState,
      page: pageConfigs,
    );
  }

  //dispose
  cancelStreams() {
    googleMapController!.dispose();
    googleMapController = null;
  }
}

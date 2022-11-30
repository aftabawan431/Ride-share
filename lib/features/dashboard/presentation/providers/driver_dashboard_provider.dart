import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_rideshare/core/utils/network/network_info.dart';
import 'package:flutter_rideshare/core/utils/services/device_info_service.dart';
import 'package:flutter_rideshare/core/utils/services/package_info_service.dart';
import 'package:flutter_rideshare/core/widgets/modals/display_status_model.dart';
import 'package:flutter_rideshare/core/widgets/modals/update_app_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/modals/no_params.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/socket_point.dart';
import '../../../../core/utils/encryption/encryption.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/location/dashboard_helper.dart';
import '../../../../core/utils/sockets/sockets.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/model/GetVehicleCapacityRequestModel.dart';
import '../../data/model/UserLocation.dart';
import '../../data/model/add_driver_route_request_model.dart';
import '../../data/model/add_passenger_schedule_request_model.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../../data/model/get_dashboard_history_rides_request_model.dart';
import '../../data/model/get_vehicle_capacity_response_model.dart';
import '../../data/model/switch_role_request_model.dart';
import '../../domain/usecase/add_driver_ride_usecase.dart';
import '../../domain/usecase/get_dashboard_data_usecase.dart';
import '../../domain/usecase/get_dashboard_history_rides_usecase.dart';
import '../../domain/usecase/get_vehicle_capacity_usecase.dart';
import '../../domain/usecase/switch_role_usecase.dart';
import '../widgets/dashboard_ride_history_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/background_location/location_service_repository.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/location/location_api.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/pages/driver_list_screen.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/pages/requested_passengers_screen.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../../ride/presentation/providers/driver_ride_provider.dart';
import '../../../ride/presentation/providers/passenger_ride_provider.dart';
import '../../domain/usecase/add_passenger_ride_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  DashBoardHelper dashBoardHelper;
  final AddDriverRideUsecase _addDriverRideUsecase;
  final AddPassengerRideUsecase _addPassengerRideUsecase;
  final GetDashboardDataUsecase _getDashboardDataUsecase;
  final SwitchRoleUsecase _switchRoleUsecase;
  final GetDashboardHistoryRidesUsecase _dashboardHistoryRidesUsecase;
  final GetVehicleCapacityUsecase _getVehicleCapacityUsecase;

  final GlobalKey<ScaffoldState> dashboardScaffoldKey = GlobalKey();

  int? responseStatusCode;

  DashboardProvider(
      this.dashBoardHelper,
      this._addDriverRideUsecase,
      this._addPassengerRideUsecase,
      this._switchRoleUsecase,
      this._getDashboardDataUsecase,
      this._getVehicleCapacityUsecase,
      this._dashboardHistoryRidesUsecase);

  GoogleMapController? googleMapController;

  TextEditingController dateTimeController = TextEditingController(
      text: DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now().toLocal()));
  TextEditingController startTimeController = TextEditingController(
      text: DateFormat('h:mm a').format(DateTime.now().toLocal()));
  TextEditingController endTimeController = TextEditingController(
      text: DateFormat('h:mm a')
          .format(DateTime.now().add(const Duration(minutes: 30)).toLocal()));

  TextEditingController kmLeverageController = TextEditingController(text: '5');
  //streams

  StreamSubscription<Position>? positionStream;
  StreamSubscription<CompassEvent>? campusStream;
  CompassEvent? lastStreamCampassEvent;
  //properties
  UserLocation? currentLocation;
  UserLocation? pickUpLocation;
  UserLocation? dropOfLocation;
  UserLocation? dashboardDropofLocation;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  final Set<Polyline> _polylines = {};

  Position? streamPosition;
  bool corporateCodeStatus = true;

  int kmLeverage = 5;

  String? dashboardDropdownValue = 'Now';
  setDashboardDropdownValue(String? value) {
    dashboardDropdownValue = value;
  }

  List<int> seats = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int selectedSeat = 1;

  double defaultBering = 192.8;
  double defaultMapTilt = 59.4;
  double defaultHeight = 270.h;

  bool isRequesting = false;
  bool isScheduled = false;

  String? selectedGender = 'any';

  DateTime? selectedSchduleDate = DateTime.now().toLocal();
  DateTime? selectedStartTime = DateTime.now().toLocal();
  DateTime? selectedEndTime =
      DateTime.now().add(const Duration(minutes: 30)).toLocal();

  ValueNotifier<bool> addDriverRideLoading = ValueNotifier(false);
  ValueNotifier<bool> switchRoleLoading = ValueNotifier(false);
  ValueNotifier<bool> getDashboardDataLoading = ValueNotifier(false);
  ValueNotifier<bool> dashboardHistoryRidesLoading = ValueNotifier(false);

  GetDashboardDataResponseModel? getDashboardDataResponseModel;

  GetDirectionModel? getDirectionModel;
  GetVehicleCapacityResponseModel? vehicleCapacityModel;

  //pagination
  bool readMoreLoading = false;
  bool showReadMore = false;
  int readMorePageNumber = 0;

  int getVehicleCapacityValue() {
    if (vehicleCapacityModel == null) {
      return 4;
    } else {
      return vehicleCapacityModel!.data.seatingCapacity;
    }
  }

  DashboardRideHistoryReponseModel? dashboardRideHistoryReponseModel;
  //usecases calls
  Future<void> addDriverRide() async {
    addDriverRideLoading.value = true;
    AuthProvider _authProvider = sl();

    var params = AddDriverRouteRequestModel(
        userId: _authProvider.currentUser!.id,
        startPoint: StartPoint(
            longitude: pickUpLocation!.longitude.toString(),
            latitude: pickUpLocation!.latitude.toString(),
            placeName: pickUpLocation!.placeFormattedAddress),
        endPoint: EndPoint(
            longitude: dropOfLocation!.longitude.toString(),
            latitude: dropOfLocation!.latitude.toString(),
            placeName: dropOfLocation!.placeFormattedAddress),
        date: isScheduled
            ? selectedSchduleDate!.toString()
            : DateTime.now().toString(),
        isScheduled: isScheduled,
        availableSeats: selectedSeat.toString(),
        vehicleId: _authProvider.currentUser!.selectedVehicle!,
        gender: selectedGender!,
        polyline: getDirectionModel!.polyline,
        bounds_ne: getDirectionModel!.bounds_ne,
        bounds_sw: getDirectionModel!.bounds_sw,
        distance: getDirectionModel!.distance,
        kmLeverage: kmLeverage,
        duration: getDirectionModel!.duration,
        activeCorporateCode: corporateCodeStatus,
        corporateCode: corporateCodeStatus
            ? _authProvider.currentUser!.corporateCode!
            : '');
    Logger().v(params.toJson());
    var loginEither = await _addDriverRideUsecase(params);

    if (loginEither.isLeft()) {
      setDefaultHeight(defaultHeight - 200.h);
      setIsRequesting(false);

      setDashboardDropOfLocation(null);
      if (responseStatusCode != null && responseStatusCode == 409) {
        ShowSnackBar.show('You have already an active route for now.');
        Timer(Duration(milliseconds: 1500), () {
          Loading.dismiss();

          AppState appState = sl();
          appState.moveToBackScreen();
          Timer(const Duration(milliseconds: 200), () {
            appState.goToNext(PageConfigs.driverSchedulesScreenPageConfig);
          });
        });
        return;
      }
      if (responseStatusCode == 408) {
        Timer(Duration(milliseconds: 2500), () {
          Loading.dismiss();
          AppState appState = sl();
          appState.goToNext(PageConfigs.userWalletPageConfig,
              pageState: PageState.addPage);
        });

        return;
      }
      DriverRideProvider driverRideProvider = sl();
      driverRideProvider.getAndSetCurrentRide(
          LocationServiceRepository.routeId ?? '',
          pageState: PageState.replace);
      handleError(loginEither);
      addDriverRideLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        AppState appState = sl();
        // appState.removePage(PageConfigs.newRidePageConfig);
        ScheduleProvider scheduleProvider = sl();
        scheduleProvider.getDriverSchedules(recall: true);

        setDateTimeControllerDefaultValue();
        bool oldIsSchedule = isScheduled;
        setIsScheduled(false);
        await setCurrentLocation(showLoading: false);
        ShowSnackBar.show('Driver route added successfully');
        setDefaultHeight(defaultHeight - 200.h);
        setIsRequesting(false);
        setDashboardDropOfLocation(null);

        //redirect to passengers list screen

        scheduleProvider.isFromNewRideScreen = true;
        if (oldIsSchedule) {
          Timer(Duration(milliseconds: 2500), () {
            AppState appState = sl();
            Loading.dismiss();
            appState.goToNext(PageConfigs.driverSchedulesScreenPageConfig);
            Timer(const Duration(milliseconds: 500), () {
              appState.removePage(PageConfigs.newRidePageConfig);
            });
          });
        } else {
          Timer(Duration(milliseconds: 2500), () {
            Loading.dismiss();
            AppState appState = sl();
            appState.currentAction = PageAction(
                page: PageConfigs.requestedPassengersPageConfigs,
                state: PageState.addWidget,
                widget: RequestedPassengersScreen(id: response.id));

            // appState.goToNext(PageConfigs.driverSchedulesScreenPageConfig);
            Timer(const Duration(milliseconds: 500), () {
              appState.removePage(PageConfigs.newRidePageConfig);
            });
          });

          // DriverRideProvider driverRideProvider = sl();
          // driverRideProvider.getAndSetCurrentRide(response.id,
          //     pageState: PageState.replace);
        }
      });
    }
  }

  Future<void> addPassengerRide() async {
    Loading.show(message: 'Adding request');
    addDriverRideLoading.value = true;
    AuthProvider _authProvider = sl();
    selectedEndTime = DateTime(
        selectedSchduleDate!.year,
        selectedSchduleDate!.month,
        selectedSchduleDate!.day,
        selectedEndTime!.hour,
        selectedEndTime!.minute);
    selectedStartTime = DateTime(
        selectedSchduleDate!.year,
        selectedSchduleDate!.month,
        selectedSchduleDate!.day,
        selectedStartTime!.hour,
        selectedStartTime!.minute);
    var params = AddPassengerScheduleRequestModel(
        userId: _authProvider.currentUser!.id,
        startPoint: StartPoint(
            longitude: pickUpLocation!.longitude.toString(),
            latitude: pickUpLocation!.latitude.toString(),
            placeName: pickUpLocation!.placeFormattedAddress),
        endPoint: EndPoint(
            longitude: dropOfLocation!.longitude.toString(),
            latitude: dropOfLocation!.latitude.toString(),
            placeName: dropOfLocation!.placeFormattedAddress),
        date: isScheduled
            ? selectedSchduleDate!.toString()
            : DateTime.now().toString(),
        time: isScheduled
            ? DateFormat('h:mm a').format(selectedSchduleDate!)
            : DateFormat('h:mm a').format(DateTime.now()),
        isScheduled: isScheduled,
        availableSeats: selectedSeat.toString(),
        vehicleId: _authProvider.currentUser!.selectedVehicle ?? '',
        gender: selectedGender!,
        polyline: getDirectionModel!.polyline,
        bounds_ne: getDirectionModel!.bounds_ne,
        bounds_sw: getDirectionModel!.bounds_sw,
        distance: getDirectionModel!.distance.toString(),
        startTime: isScheduled
            ? selectedStartTime!.toString()
            : DateTime.now().toString(),
        endTime: isScheduled
            ? selectedEndTime!.toString()
            : DateTime.now().add(const Duration(minutes: 30)).toString(),
        duration: getDirectionModel!.duration,
        activeCorporateCode: corporateCodeStatus,
        corporateCode: corporateCodeStatus
            ? _authProvider.currentUser!.corporateCode!
            : '');
    var loginEither = await _addPassengerRideUsecase(params);

    if (loginEither.isLeft()) {
      if (responseStatusCode == 408) {
        Timer(Duration(milliseconds: 1500), () {
          Loading.dismiss();
          AppState appState = sl();
          appState.goToNext(PageConfigs.userWalletPageConfig,
              pageState: PageState.addPage);
        });

        return;
      }
      // else if(responseStatusCode == 400){
      //     Timer(Duration(milliseconds: 1500), () {
      //       Loading.dismiss();
      //
      //       ShowSnackBar.show('heay bro ');
      //     });
      //     return;
      // }
      addDriverRideLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        bool oldSchduleValue = false;

        ScheduleProvider scheduleProvider = sl();
        scheduleProvider.getPassengerSchedules(recall: true);
        await setCurrentLocation(showLoading: false);

        setDefaultHeight(defaultHeight - 200.h);
        setDateTimeControllerDefaultValue();
        setIsRequesting(false);
        oldSchduleValue = isScheduled;
        setIsScheduled(false);
        setDashboardDropOfLocation(null);

        ShowSnackBar.show('Schedule added successfully!');

        scheduleProvider.isFromNewRideScreen = true;
        AppState appState = sl();
        Logger().v("Getting this response");
        Logger().v(response.toJson());

        if (oldSchduleValue) {
          Timer(Duration(milliseconds: 2500), () {
            Loading.dismiss();
            appState.goToNext(PageConfigs.passengerSchedulesScreenPageConfig);
            Timer(const Duration(milliseconds: 300), () {
              appState.removePage(PageConfigs.newRidePageConfig);
            });
          });
        } else {
          Timer(Duration(milliseconds: 2500), () {
            appState.currentAction = PageAction(
                widget: DriverListScreen(id: response.id),
                page: PageConfigs.driversListPageConfig,
                state: PageState.addWidget);
            Timer(const Duration(milliseconds: 300), () {
              appState.removePage(PageConfigs.newRidePageConfig);
            });
          });
        }
      });
    }
  }

  Future<void> getDashboardData({bool showLoading = true}) async {
    if (showLoading) {
      getDashboardDataLoading.value = true;
    }

    var loginEither = await _getDashboardDataUsecase(NoParams());

    if (loginEither.isLeft()) {
      Loading.dismiss();
      handleError(loginEither);
      getDashboardDataLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getDashboardDataLoading.value = false;
        getDashboardDataResponseModel = response;
        if (response.data.appVersion != null &&
            response.data.appVersion!.forceUpdate &&
            showLoading) {
          final info = await PackageInfoService().get();

          if (Platform.isAndroid) {
            if (info.version
                    .compareTo(response.data.appVersion!.androidVersion) ==
                -1) {
              UpdateAppModel appModel =
                  UpdateAppModel(navigatorKeyGlobal.currentContext!);
              appModel.show();
            }
          } else {}
        }

        notifyListeners();
      });
    }
  }

  Future<void> getDashboardHistoryRides(String check,
      {bool isFirstTime = true}) async {
    AuthProvider _authProvider = sl();


    if (isFirstTime) {
      dashboardHistoryRidesLoading.value = true;
      showReadMore = true;
      readMorePageNumber = 0;

      // notifyListeners();
    } else {
      readMoreLoading = true;
      notifyListeners();
    }
    final params = GetDashboardHistoryRidesRequestModel(
        userId: _authProvider.currentUser!.id,
        check: check,
        isDriver: _authProvider.currentUser!.selectedUserType == '1',
        page: readMorePageNumber);

    var loginEither = await _dashboardHistoryRidesUsecase(params);

    if (loginEither.isLeft()) {
      Loading.dismiss();
      handleError(loginEither);
      dashboardHistoryRidesLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {

        dashboardHistoryRidesLoading.value = false;
        readMorePageNumber=readMorePageNumber+1;
        if (!isFirstTime) {
          if (response.data.isEmpty||response.data.length<5) {
            showReadMore = false;
          }
          readMoreLoading=false;
          print(response.data.length);

          dashboardRideHistoryReponseModel!.data.addAll(response.data);
          notifyListeners();


        } else {
          if(response.data.length<5){
            showReadMore=false;
          }
          dashboardRideHistoryReponseModel = response;
        }



      });
    }
  }

  Future<void> getVehicleCapacity() async {
    AuthProvider _authProvider = sl();
    final params = GetVehicleCapacityRequestModel(
        userId: _authProvider.currentUser!.id,
        vehicleId: _authProvider.currentUser!.selectedVehicle!);
    var loginEither = await _getVehicleCapacityUsecase(params);

    if (loginEither.isLeft()) {
      Loading.dismiss();
      handleError(loginEither);
      getDashboardDataLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        vehicleCapacityModel = response;
        Logger().v(response.toJson());
      });
    }
  }

  setDriverVehicleCapacity() async {
    AuthProvider authProvider = sl();

    if (vehicleCapacityModel == null ||
        vehicleCapacityModel!.data.id !=
            authProvider.currentUser!.selectedVehicle) {
      Logger().v("Getting capacity");
      await getVehicleCapacity();
    } else {}
  }

  Future<void> switchRole() async {
    Loading.show(message: 'Switching');
    AuthProvider _authProvider = sl();

    final params =
        SwitchRoleRequestModel(userId: _authProvider.currentUser!.id);

    var loginEither = await _switchRoleUsecase(params);

    if (loginEither.isLeft()) {
      onBackPress = null;
      if (responseStatusCode != null && responseStatusCode == 401) {
        DisplayStatusModel model = DisplayStatusModel(
            navigatorKeyGlobal.currentContext!,
            icon: AppAssets.alertIconPng,
            title: "Rahper",
            content: "Your documents are being verified!");
        model.show();
      } else {
        handleError(loginEither);
      }
      Loading.dismiss();
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        Loading.dismiss();
        Logger().v(response.data.toJson());
        _authProvider.currentUser = response.data;
        await _authProvider.updateUserOnDisk();
        AppState appState = sl();
        appState.currentAction = PageAction(
          state: PageState.replaceAll,
          page: PageConfigs.splashPageConfig,
        );
      });
    }
  }
  //getters

  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;
  Set<Polyline> get polylines => _polylines;

  // driver ride start listner for passenger so passenger could be redirected to the active ride screen
  void driverStartRideListener() {
    AuthProvider authProvider = sl();
    String event = SocketPoint.redirectPassengerToActiveRideListner;
    if (authProvider.currentUser!.selectedUserType == '2') {
      SocketService.on(event, (data) {
        final decodedData = Encryption.decryptJson(jsonDecode(data));
        PassengerRideProvider passengerRideProvider = sl();
        passengerRideProvider.getAndSetCurrentRide(
            routeId: decodedData['routeId'],
            scheduleId: decodedData['scheduleId']);
      });
    }
  }

  void driverStartRideListnerOff() {
    AuthProvider authProvider = sl();

    if (authProvider.currentUser!.selectedUserType == '2') {
      SocketService.off(SocketPoint.redirectPassengerToActiveRideListner);
    }
  }

  setErrorListener() {
    String event = SocketPoint.errorListner;
    SocketService.on(event, (data) {
      Logger().v("It is coming");
      Loading.dismiss();
      ShowSnackBar.show(jsonDecode(data)['msg']);
    });
  }

  refreshDashboardListner(bool isOn) {
    String event = SocketPoint.refreshDashboardListner;
    if (isOn) {
      SocketService.on(event, (data) {
        getDashboardData(showLoading: false);
      });
      // SocketService.socket!.on(SocketPoint.refreshDashboardListner, );
    } else {
      SocketService.off(event);
    }
  }

  deviceInfoUpdates(bool isOn) {
    String event = SocketPoint.deviceUpdatesListener;
    if (isOn) {
      SocketService.on(event, (data) async {
        final decryptedResponse = Encryption.decryptJson(jsonDecode(data));
        Logger().v(decryptedResponse);
        final updatedDeviceId = decryptedResponse['deviceId'];
        final myDeviceId = await getDeviceId();
        if (updatedDeviceId != myDeviceId) {
          AuthProvider authProvider = sl();
          await authProvider.logout();
          ShowSnackBar.show('Already account logged in on another device');
        }
      });
      // SocketService.socket!.on(SocketPoint.refreshDashboardListner, );
    } else {
      SocketService.off(event);
    }
  }

  setCurrentLocation({bool showLoading = true}) async {
    try {
      if (currentLocation == null) {
        if (showLoading) {
          Loading.show(message: 'Getting location');
        }
        if (userCurrentLocation == null) {
          final position = await LocationApi.determinePosition();
          userCurrentLocation = position;
        }
        currentLocation =
            await dashBoardHelper.searchCoordinateAddress(userCurrentLocation!);
      }
      if (showLoading) {
        Loading.dismiss();
      }

      _markers.clear();
      _circles.clear();
      _polylines.clear();
      // Uint8List customMarker =
      //     await dashBoardHelper.makeCustomMarker(AppAssets.homenavSvg);
      // addMarker(
      //   Marker(
      //       markerId: const MarkerId('current'),
      //       icon: BitmapDescriptor.fromBytes(customMarker),
      //       anchor: const Offset(0.5, 0.5),
      //       rotation: position.heading,
      //
      //       position: LatLng(
      //         currentLocation!.latitude,
      //         currentLocation!.longitude,
      //       ),
      //       infoWindow:
      //           InfoWindow(title: currentLocation!.placeFormattedAddress)),
      // );
      // addCircle(Circle(
      //     circleId: const CircleId('current'),
      //     center: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      //     radius: 150,
      //     fillColor: const Color.fromRGBO(76, 228, 77, .1),
      //     strokeColor: Colors.transparent));
      if (isRequesting) {
        moveToCurrentLocation();
      }
      setPickUpdLocationValue(currentLocation!);
      // setDropOfLocation(null);

      notifyListeners();
    } catch (e) {
      Loading.dismiss();
      ShowSnackBar.show(e.toString());
    }
  }

  clearMapsFields() {}
  void moveToCurrentLocation() {
    if (currentLocation != null) {
      googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(currentLocation!.latitude, currentLocation!.longitude),
              zoom: 17)));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    googleMapController = controller;
    // setCurrentUserLocationStream();
    await setCurrentLocation();
    if (currentLocation == null) {
      return;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        zoom: 17)));
  }

  //setters

  addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  addCircle(Circle circle) {
    _circles.add(circle);
    notifyListeners();
  }

  setPickUpdLocationValue(UserLocation value) {
    pickUpLocation = value;
    notifyListeners();
  }

  setPickUpLocation(String value) async {
    final result = await dashBoardHelper.getPlaceAddressDetails(value);

    pickUpLocation = result;
    notifyListeners();
  }

  setDropOfLocation(String? value) async {
    if (value != null) {
      final result = await dashBoardHelper.getPlaceAddressDetails(value);
      dropOfLocation = result;
    } else {
      dropOfLocation = null;
    }

    notifyListeners();
  }

  Future setDashboardDropOfLocation(String? value) async {
    if (value != null) {
      final result = await dashBoardHelper.getPlaceAddressDetails(value);
      dashboardDropofLocation = result;
    } else {
      dashboardDropofLocation = null;
    }

    notifyListeners();
  }

  addPolyline(Polyline value) {
    _polylines.add(value);
    notifyListeners();
  }

  setIsRequesting(bool value) {
    isRequesting = value;
    notifyListeners();
  }

  setIsScheduled(bool value) {
    isScheduled = value;
    notifyListeners();
  }

  setSelectedSeat(int index) {
    selectedSeat = index;
    notifyListeners();
  }

  setDefaultHeight(double value) {
    defaultHeight = value;
    notifyListeners();
  }

  setSelectedGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  //streams
  setCurrentUserLocationStream() {
    if (positionStream != null) {
      return;
    }

    campusStream = FlutterCompass.events?.listen((event) async {
      if (isRequesting && streamPosition == null) return;
      if (event.heading == null) {
        return;
      }
      if (currentLocation == null) {
        return;
      }
      lastStreamCampassEvent = event;
      // addMarker(
      //   Marker(
      //     markerId: const MarkerId('current'),
      //     icon: BitmapDescriptor.fromBytes(customMarker),
      //     anchor: const Offset(0.5, 0.5),
      //     rotation: event.heading!,
      //     position: LatLng(
      //       streamPosition!.latitude,
      //       streamPosition!.longitude,
      //     ),
      //   ),
      // );
      // addCircle(Circle(
      //     circleId: CircleId('current'),
      //     center: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      //     radius: 150,
      //     fillColor: const Color.fromRGBO(76, 228, 77, .1),
      //     strokeColor: Colors.transparent));
      notifyListeners();
    });
    // positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position? position) async {
    //   if (position == null) return;
    //   streamPosition=position;
    //
    //   if(isRequesting)
    //     return;
    //   if(lastStreamCampassEvent==null){
    //     return;
    //   }
    //
    //   Uint8List customMarker =
    //       await dashBoardHelper.makeCustomMarker(AppAssets.homenavSvg);
    //   addMarker(
    //     Marker(
    //       markerId: const MarkerId('current'),
    //       icon: BitmapDescriptor.fromBytes(customMarker),
    //       anchor: const Offset(0.5, 0.5),
    //       rotation:lastStreamCampassEvent!.heading??0,
    //       position: LatLng(
    //         position.latitude,
    //         position.longitude,
    //       ),
    //     ),
    //   );
    //   addCircle(Circle(
    //       circleId: CircleId('current'),
    //       center: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    //       radius: 150,
    //       fillColor: const Color.fromRGBO(76, 228, 77, .1),
    //       strokeColor: Colors.transparent));
    //   notifyListeners();
    // });
  }

  getAndSetPolyline() async {
    Loading.show(message: 'Getting directions');
    final result = await dashBoardHelper.getDirection(
      LatLng(pickUpLocation!.latitude, pickUpLocation!.longitude),
      LatLng(dropOfLocation!.latitude, dropOfLocation!.longitude),
    );
    getDirectionModel = result;
    _markers.clear();
    _circles.clear();
    Uint8List endMarker =
        await dashBoardHelper.makeCustomMarker(AppAssets.locationSvg);
    addMarker(
      Marker(
          markerId: const MarkerId('end-location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          // anchor: Offset(0.5, 0.5),
          position: LatLng(
            result.endLocation.latitude,
            result.endLocation.longitude,
          ),
          infoWindow:
              InfoWindow(title: currentLocation!.placeFormattedAddress)),
    );

    Uint8List starMarket =
        await dashBoardHelper.makeCustomMarker(AppAssets.fromSvg, width: 70);
    addMarker(
      Marker(
          markerId: const MarkerId('start-location'),
          icon: BitmapDescriptor.fromBytes(starMarket),
          anchor: const Offset(0.5, 0.5),
          position: LatLng(
            result.startLocation.latitude,
            result.startLocation.longitude,
          ),
          infoWindow: InfoWindow(
            title: currentLocation!.placeFormattedAddress,
          ),
          onTap: () {
            Logger().v('Go to that point');
          }),
    );

    _polylines.clear();
    addPolyline(Polyline(
        polylineId: PolylineId(
          DateTime.now().toString(),
        ),
        points: result.polylineDecoded
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
        color: Colors.purple,
        width: 3));

    // late LatLngBounds bounds;
    //
    //  if (result.startLocation.latitude > result.endLocation.latitude &&
    //      result.startLocation.latitude > result.endLocation.longitude) {
    //    bounds = LatLngBounds(southwest: result.endLocation, northeast: result.startLocation);
    //  } else if (result.startLocation.latitude >result.endLocation.longitude) {
    //    bounds = LatLngBounds(
    //        southwest: LatLng(result.startLocation.latitude,result.endLocation.longitude),
    //        northeast: LatLng(result.endLocation.latitude, result.startLocation.latitude));
    //  } else if (result.startLocation.latitude > result.endLocation.latitude) {
    //    bounds = LatLngBounds(
    //        southwest: LatLng(result.endLocation.latitude, result.startLocation.latitude),
    //        northeast: LatLng(result.startLocation.latitude, result.endLocation.longitude));
    //  } else {
    //    bounds = LatLngBounds(southwest: result.startLocation, northeast: result.endLocation);
    //  }

    // googleMapController!.animateCamera((CameraUpdate.newLatLngBounds(
    //     LatLngBounds(southwest: result.bounds_sw, northeast: result.bounds_ne),
    //
    //     40)));
    googleMapController!.animateCamera((CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: result.bounds_sw, northeast: result.bounds_ne),
        50)));
    Loading.dismiss();
  }

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }

  addKmLeverage() {
    kmLeverage = ++kmLeverage;
    notifyListeners();
  }

  subtractKmLeverage() {
    kmLeverage = --kmLeverage;
    notifyListeners();
  }

  changeCorporateCodeStatus(bool value) {
    corporateCodeStatus = value;
    notifyListeners();
  }

  setDateTimeControllerDefaultValue() {
    AuthProvider authProvider = sl();
    startTimeController = TextEditingController(
        text: DateFormat('h:mm a').format(DateTime.now().toLocal()));
    endTimeController = TextEditingController(
        text: DateFormat('h:mm a')
            .format(DateTime.now().add(const Duration(minutes: 30)).toLocal()));
    selectedSchduleDate = DateTime.now().toLocal();
    selectedStartTime = DateTime.now().toLocal();
    selectedEndTime = DateTime.now().add(const Duration(minutes: 30)).toLocal();
    if (authProvider.currentUser!.selectedUserType == '1') {
      dateTimeController = TextEditingController(
          text:
              DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now().toLocal()));
    } else {
      dateTimeController = TextEditingController(
          text: DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal()));
    }
  }

  Future<String> getDeviceId() async {
    DeviceInfoService deviceInfoService = sl();
    return await deviceInfoService.getUniqueDeviceId();
  }

  syncIfAnyCachedRides() async {
    FlutterSecureStorage secureStorage = sl();
    final data = await secureStorage.read(key: 'pendingRides');
    NetworkInfo networkInfo = sl();
    if (!await networkInfo.isConnected) {
      return;
    }

    if (data != null) {
      final decoded = jsonDecode(data);

      for (var item in decoded) {
        Logger().v(item);
        item.remove('status');
        Logger().v(SocketService.socket!.connected);
        final encryptedParams = Encryption.encryptObject(jsonEncode(item));
        Logger().v(encryptedParams);
        SocketService.socket!.emitWithAck(
            SocketPoint.completeRideEmitter, jsonEncode(encryptedParams),
            ack: (data) {
          // Loading.dismiss();
          Logger().v(data);
        });
      }
    }
    await secureStorage.delete(key: 'pendingRides');
  }
}

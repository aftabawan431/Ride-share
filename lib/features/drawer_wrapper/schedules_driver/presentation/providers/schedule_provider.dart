import 'dart:convert';
import 'dart:developer' as developer;
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../../core/modals/error_response_model.dart';
import '../../../../../core/utils/constants/socket_point.dart';
import '../../../../../core/utils/encryption/encryption.dart';
import '../../../../../core/utils/globals/loading.dart';
import '../../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../data/models/get_drivers_list_request_model.dart';
import '../../data/models/get_drivers_list_response_model.dart';
import '../../data/models/get_requested_passenger_request_model.dart';
import '../../data/models/get_schedules_requests_model.dart';
import '../../data/models/get_driver_schedules_response_model.dart';
import '../../data/models/requests_length_model.dart';
import '../../data/models/reschdule_passenger_schedule_request_model.dart';
import '../../data/models/reshedule_driver_route_request_model.dart';
import '../../domain/usecases/get_driver_list_usecase.dart';
import '../../domain/usecases/get_driver_schedules_usecase.dart';
import '../../domain/usecases/get_passenger_schdules_usecase.dart';
import '../../domain/usecases/get_requested_passenger_usecase.dart';
import '../../domain/usecases/reshedule_driver_route_usecase.dart';
import '../../domain/usecases/reshedule_passenger_schedule_usecase.dart';
import '../../../../ride/presentation/providers/passenger_ride_provider.dart';
import 'package:logger/logger.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/utils/sockets/sockets.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/models/get_passenger_schdules_response_model.dart';
import '../../data/models/get_requested_passenger_response_model.dart';

class ScheduleProvider extends ChangeNotifier {
  ScheduleProvider(
      this._getSchedulesUsecase,
      this._getPassengerSchedulesUsecase,
      this._getDriversListUsecase,
      this._getRequestedPassengersUsecase,
      this._rescheduleDriverRouteUsecase,
      this._reschedulePassengerScheduleUsecase);

  //value notifiers
  ValueNotifier<bool> getSchedulesLoading = ValueNotifier(false);
  ValueNotifier<bool> getDriversListLoading = ValueNotifier(true);
  ValueNotifier<bool> getRequestedPassengersLoading = ValueNotifier(true);
  AuthProvider authProvider = sl();

  bool readMoreloading = false;
  int skip = 5;

  //usecases
  final GetDriverSchedulesUsecase _getSchedulesUsecase;
  final GetPassengerSchedulesUsecase _getPassengerSchedulesUsecase;
  final GetRequestedPassengersUsecase _getRequestedPassengersUsecase;
  final GetDriversListUsecase _getDriversListUsecase;
  final RescheduleDriverRouteUsecase _rescheduleDriverRouteUsecase;
  final ReschedulePassengerScheduleUsecase _reschedulePassengerScheduleUsecase;

  //properties

  GetDriverSchedulesResponseModel? getSchedulesResponseModel;
  GetDriversListResponseModel? getDriversListResponseModel;
  GetPassengerSchdulesResponseModel? getPassengerSchdulesResponseModel;
  GetRequestedPassengerResponseModel? getRequestedPassengerResponseModel;

  ValueNotifier<RequestsLengthModel?> requestsLength = ValueNotifier(null);

  // this bool will check if user has directly come to requests or driver list screen
  bool isFromNewRideScreen = false;

  int schedulePageNumber = 0;
  bool scheduleReadMore = true;
  Future<void> getDriverSchedules(
      {bool recall = false, bool isFirstTime = true}) async {
    // if (getSchedulesResponseModel != null&&isFirstTime==true) {
    //   if (!recall) {
    //     return;
    //   }
    // }

    if (isFirstTime) {
      getSchedulesLoading.value = true;
      scheduleReadMore = true;
      schedulePageNumber = 0;
      // notifyListeners();
    } else {
      readMoreloading = true;
      notifyListeners();
    }

    AuthProvider authProvider = sl();

    var params = GetSchedulesRequestModel(
        userId: authProvider.currentUser!.id,
        isDriver: authProvider.currentUser!.selectedUserType == '1',
        page: schedulePageNumber);

    var loginEither = await _getSchedulesUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getSchedulesLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getSchedulesLoading.value = false;
        schedulePageNumber = schedulePageNumber + 1;
        if (!isFirstTime) {
          if (response.data.isEmpty || response.data.length < skip) {
            scheduleReadMore = false;
          }
          readMoreloading = false;
          getSchedulesResponseModel!.data.addAll(response.data);
        } else {
          if (response.data.length < skip) {
            scheduleReadMore = false;
          }
          getSchedulesLoading.value = false;
          getSchedulesResponseModel = response;
        }

        notifyListeners();
      });
    }
  }

  Future<void> getPassengerSchedules(
      {bool recall = false, bool isFirstTime = true}) async {
    Logger().v('These are schedules');
    // if (getSchedulesResponseModel != null) {
    //   if (!recall) {
    //     return;
    //   }
    // }

    if (isFirstTime) {
      getSchedulesLoading.value = true;
      scheduleReadMore = true;
      schedulePageNumber = 0;

      // notifyListeners();
    } else {
      readMoreloading = true;
      notifyListeners();
    }
    AuthProvider authProvider = sl();

    var params = GetSchedulesRequestModel(
        userId: authProvider.currentUser!.id,
        isDriver: authProvider.currentUser!.selectedUserType == '1',
        page: schedulePageNumber);

    var loginEither = await _getPassengerSchedulesUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getSchedulesLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getSchedulesLoading.value = false;
        schedulePageNumber = schedulePageNumber + 1;
        if (!isFirstTime) {
          if (response.data.isEmpty || response.data.length < skip) {
            scheduleReadMore = false;
          }
          readMoreloading = false;
          getPassengerSchdulesResponseModel!.data.addAll(response.data);
        } else {
          getSchedulesLoading.value = false;
          if (response.data.length < skip) {
            scheduleReadMore = false;
          }
          getPassengerSchdulesResponseModel = response;
        }

        notifyListeners();
      });
    }
  }

  Future<void> rescheduleDriverRoute({required String routeId}) async {
    Loading.show(message: 'Requesting');

    DashboardProvider dashboardProvider = sl();

    var params = RescheduleDriverRouteRequestModel(
        routeId: routeId,
        date: dashboardProvider.selectedSchduleDate!.toString());

    var loginEither = await _rescheduleDriverRouteUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      Loading.dismiss();
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        DashboardProvider dashboardProvider = sl();
        dashboardProvider.setDateTimeControllerDefaultValue();

        Loading.dismiss();
        getDriverSchedules(recall: true);
      });
    }
  }

  Future<void> reschedulePassengerSchedule({required String scheduleId}) async {
    Logger().v('These are schedules');

    Loading.show(message: 'Requesting');

    DashboardProvider dashboardProvider = sl();

    var params = ReschedulePassengerScheduleRequestModel(
        scheduleId: scheduleId,
        date: dashboardProvider.selectedSchduleDate!.toString(),
        startTime: dashboardProvider.selectedStartTime.toString(),
        endTime: dashboardProvider.selectedEndTime.toString());

    var loginEither = await _reschedulePassengerScheduleUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      Loading.dismiss();
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        DashboardProvider dashboardProvider = sl();
        dashboardProvider.setDateTimeControllerDefaultValue();

        Loading.dismiss();
        getPassengerSchedules(recall: true);
      });
    }
  }

  // it will refresh the schedules list whenever driver will start a ride
  void refreshSchedulesSocketOn() {
    Logger().v('listening');
    SocketService.on(SocketPoint.refreshPassengerScheduleListner, (data) {
      developer.log(data);
      Logger().v("it is here");

      final decrypted = Encryption.decryptJson(jsonDecode(data));
      getPassengerSchdulesResponseModel =
          GetPassengerSchdulesResponseModel.fromJson(decrypted);
      notifyListeners();
    });
  }

  finishRideDriver(String rideRide, {bool fromModal = false}) {
    final encryptedParams =
        Encryption.encryptObject(jsonEncode({"routeId": rideRide}));

    SocketService.socket!.emitWithAck(
        SocketPoint.finishDriverActiveRideEmit, jsonEncode(encryptedParams),
        ack: (data) async {
      await ClearAllNotifications.clear();

      getDriverSchedules(recall: true);
      Loading.dismiss();
      if (fromModal) {
        AppState appState = sl();
        appState.moveToBackScreen();
      }
    });
  }

  //if status is actie then driver can cancel the ride
  cancelRouteDriver(String rideRide) {
    Loading.show(message: 'Cancelling');
    final encryptedParams =
        Encryption.encryptObject(jsonEncode({"routeId": rideRide}));
    SocketService.socket!.emitWithAck(
        SocketPoint.cancelDriverRouteEmit, jsonEncode(encryptedParams),
        ack: (data) {
      getDriverSchedules(recall: true);
      Loading.dismiss();
    });
  }

  deleteRouteDriver(String rideRide) {
    Loading.show(message: 'Deleting');
    final encryptedParams =
        Encryption.encryptObject(jsonEncode({"routeId": rideRide}));

    SocketService.socket!.emitWithAck(
        SocketPoint.deleteDriverRouteEmit, jsonEncode(encryptedParams),
        ack: (data) {
      getDriverSchedules(recall: true);
      Loading.dismiss();
    });
  }

  Future<void> getRequestedPassengers(String id) async {
    getRequestedPassengersLoading.value = true;

    var params = GetRequestedPassengersRequestModel(routeId: id);

    var loginEither = await _getRequestedPassengersUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getRequestedPassengersLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getRequestedPassengersLoading.value = false;
        getRequestedPassengerResponseModel = response;

        notifyListeners();
      });
    }
  }

  //passengers
  //it will cancel the accepted pass
  cancelPassengerScheduledRide(
      {required String routeId,
      required String scheduleId,
      required String reason,
      bool moveToBack = false}) {
    final data = {
      "routeId": routeId,
      "scheduleId": scheduleId,
      "reason": reason
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    SocketService.socket!.emitWithAck(
        SocketPoint.cancelPassengerScheduleEmit, jsonEncode(encryptedParams),
        ack: (data) {
      getPassengerSchedules(recall: true);
      Loading.dismiss();
      if (moveToBack) {
        AppState appState = sl();
        appState.moveToBackScreen();
      }
    });
  }

  cancelPassengerInrideScheduledRide(
      {required String routeId,
      required String scheduleId,
      required String reason,
      bool moveToBack = false}) {
    PassengerRideProvider provider = sl();

    final data = {
      "routeId": routeId,
      "passengerId": provider.currentRide!.data.schedule.id,
      "reason": reason
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    SocketService.socket!.emitWithAck(
        SocketPoint.inRidePassengerScheduleEmit, jsonEncode(encryptedParams),
        ack: (data) {
          Loading.dismiss();
      getPassengerSchedules(recall: true);
      AppState appState = sl();
      appState.moveToBackScreen();
    });
  }

  deletePassengerSchedule({required String scheduleId}) {
    final data = {"scheduleId": scheduleId};
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    SocketService.socket!.emitWithAck(
        SocketPoint.deteleSchedule, jsonEncode(encryptedParams), ack: (data) {
      getPassengerSchedules(recall: true);
    });
  }

  Future<void> getDriversList(String id, {bool recall = false}) async {
    // if (getDriversListResponseModel != null) {
    //   if (!recall) {

    //     return;
    //   }
    // }

    getDriversListLoading.value = true;
    var params = GetDriversListRequestModel(isScheduled: false, scheduleId: id);
    var loginEither = await _getDriversListUsecase(params);
    if (loginEither.isLeft()) {
      handleError(loginEither);
      getDriversListLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getDriversListLoading.value = false;
        getDriversListResponseModel = response;

        notifyListeners();
      });
    }
  }

  refreshDriverScheduleListner() {
    SocketService.on('refreshDriverRoutes', (data) {
      getDriverSchedules(recall: true);
    });
  }

  refreshDriverScheduleListnerOff() {
    SocketService.off('refreshDriverRoutes');
  }

  //doing this to check if passenger is in drivers list screen, only then i will refresh the drivers list'
  bool isInDriverListScreen = false;
  // driver action listener
  // it will refersh the drivers list when driver action will be accpeted or rejected
  void driverActionsListener() {
    Logger().v('Refreshing listner');
    SocketService.on(SocketPoint.refreshEverything, (data) {
      // ShowSnackBar.show('Refresh everything listener working');
      Logger().v(data);
      final decodedData = Encryption.decryptJson(jsonDecode(data));

      if (isInDriverListScreen) {
        refreshDriversList();

        if (decodedData['rideStatus'] != null &&
            decodedData['rideStatus'] == 'accepted' &&
            isFromNewRideScreen == false) {
          getPassengerSchedules(recall: true);

          AppState appState = sl();
          appState.moveToBackScreen();
        }
        // ShowSnackBar.show("Working now");
      } else {
        if (decodedData['rideStatus'] != null &&
            decodedData['rideStatus'] == 'accepted') {
          getPassengerSchedules(recall: true);
        }
      }

      //
      Logger().v(data);
    });
  }

//sockets calls
  void refreshDriversList() {
    Logger().v('calling this');
    if (getDriversListResponseModel == null) {
      return;
    }
    Loading.show(message: 'Loading');
    final params = {
      "scheduleId": getDriversListResponseModel!.data.schedule.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(params));

    SocketService.socket!.emitWithAck(
        SocketPoint.matchDriversEmit, jsonEncode(encryptedParams), ack: (data) {
      Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);
      getDriversListResponseModel =
          GetDriversListResponseModel.fromJson(decryptedResponse['data']);
      notifyListeners();
    });
  }

  void newrequest(String id) {
    Loading.show(message: 'Requesting');
    final data = {
      "routeId": id,
      "scheduleId": getDriversListResponseModel!.data.schedule.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    SocketService.socket!.emitWithAck(
        SocketPoint.rideRequestToDriverEmit, jsonEncode(encryptedParams),
        ack: (data) {
      Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);
      getDriversListResponseModel =
          GetDriversListResponseModel.fromJson(decryptedResponse['data']);
      notifyListeners();
      Logger().v(data);

      // handleSocketAwk(jsonDecode(data));
    });
  }

  void acceptDriverRequest(String id) {
    Loading.show(message: 'Accepting');
    final data = {
      "routeId": id,
      "scheduleId": getDriversListResponseModel!.data.schedule.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));

    SocketService.socket!.emitWithAck(
        SocketPoint.acceptRequestByPassenger, jsonEncode(encryptedParams),
        ack: (data) async {
      Loading.dismiss();
      ScheduleProvider scheduleProvider = sl();
      await scheduleProvider.getPassengerSchedules(recall: true);
      AppState appState = sl();
      appState.moveToBackScreen();

      return;

      final decryptedResponse = Encryption.decryptJson(data);
      getDriversListResponseModel =
          GetDriversListResponseModel.fromJson(decryptedResponse['data']);
      notifyListeners();
      Logger().v(data);

      // handleSocketAwk(jsonDecode(data));
    });
  }

  //driver
  void accpetRequest(String id) {
    Loading.show(message: 'Accepting');

    final data = {
      "scheduleId": id,
      "routeId": getRequestedPassengerResponseModel!.data.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    SocketService.socket!.emitWithAck(
        SocketPoint.acceptRequestByDriver, jsonEncode(encryptedParams),
        ack: (data) {
      Loading.dismiss();
      refreshRequestedList();
      final decryptedResponse = Encryption.decryptJson(data);
      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);
      handleSocketAwk(SocketAwkResponseModel.fromJson(decryptedResponse));
      getDriverSchedules(recall: true);
    });
  }

  void sendRequestToPasenger(String id) {
    Loading.show(message: 'Requesting');

    final data = {
      "scheduleId": id,
      "routeId": getRequestedPassengerResponseModel!.data.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    SocketService.socket!.emitWithAck(
        SocketPoint.sendRequestToPassengerByDriver, jsonEncode(encryptedParams),
        ack: (data) {
      Loading.dismiss();
      refreshRequestedList();
      final decryptedResponse = Encryption.decryptJson(data);
      ScheduleProvider scheduleProvider = sl();
      scheduleProvider.getDriverSchedules(recall: true);
      Logger().v(decryptedResponse);
      handleSocketAwk(SocketAwkResponseModel.fromJson(decryptedResponse));
      getDriverSchedules(recall: true);
    });
  }

  // Reject Request
  void rejectRequest(String id) {
    Loading.show(message: 'Requesting');

    Logger().v(SocketService.socket!.connected);
    final data = {
      "routeId": id,
      "scheduleId": getDriversListResponseModel!.data.schedule.id,
    };
    final encryptedParams = Encryption.encryptObject(jsonEncode(data));
    SocketService.socket!.emitWithAck(
        SocketPoint.rejectRequestOfDriverEmit, jsonEncode(encryptedParams),
        ack: (data) {
      Loading.dismiss();
      final decryptedResponse = Encryption.decryptJson(data);
      getDriversListResponseModel =
          GetDriversListResponseModel.fromJson(decryptedResponse['data']);
      notifyListeners();
      Logger().v(data);
      // handleSocketAwk(SocketAwkResponseModel.fromJson(jsonDecode(data)));
    });
  }

  // void getRefreshRequestedList() {
  //   SocketService.socket!.on('getrequests', (data) {
  //     Logger().v(data);
  //     getRequestedPassengerResponseModel =
  //         GetRequestedPassengerResponseModel.fromJson(jsonDecode(data));
  //     notifyListeners();
  //   });
  // }

  void refreshRequestedList() {
    final encryptedParams = Encryption.encryptObject(
        jsonEncode({"routeId": getRequestedPassengerResponseModel!.data.id}));
    SocketService.socket!.emitWithAck(
        SocketPoint.requestedPassengersEmit, jsonEncode(encryptedParams),
        ack: (data) {
      Logger().v(data);
      final decryptedResponse = Encryption.decryptJson(data);
      getRequestedPassengerResponseModel =
          GetRequestedPassengerResponseModel.fromJson(decryptedResponse);
      notifyListeners();
    });
  }

  /// it will be hit when passenger will send new request
  void newRequestDriver() {
    SocketService.on(SocketPoint.driverNewRequestOn, (data) {
      if (authProvider.currentUser!.selectedUserType == '1') {
        refreshRequestedList();
      }
    });
  }

  void rejectPassengerRequest(String id) {
    final encryptedParams = Encryption.encryptObject(jsonEncode({
      "routeId": getRequestedPassengerResponseModel!.data.id,
      "scheduleId": id,
    }));
    SocketService.socket!.emitWithAck(
        SocketPoint.rejectRequestByDriver, jsonEncode(encryptedParams),
        ack: (data) {
      refreshRequestedList();
      final decryptedResponse = Encryption.decryptJson(data);

      handleSocketAwk(SocketAwkResponseModel.fromJson(decryptedResponse));
    });
  }

  void cancelPassengerRide(String id, String reason) {
    final encryptedParams = Encryption.encryptObject(jsonEncode({
      "routeId": getRequestedPassengerResponseModel!.data.id,
      "scheduleId": id,
      "reason": reason
    }));
    Loading.show(message: 'Cancelling');
    SocketService.socket!.emitWithAck(
        SocketPoint.cancelPassengerRideByDriver, jsonEncode(encryptedParams),
        ack: (data) {
      Loading.dismiss();
      refreshRequestedList();
      final decryptedResponse = Encryption.decryptJson(data);

      handleSocketAwk(SocketAwkResponseModel.fromJson(decryptedResponse));
      getDriverSchedules(recall: true);
    });
  }

  //error handlers

  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }

  void handleSocketAwk(SocketAwkResponseModel model) {
    ShowSnackBar.show(model.msg);
  }
}

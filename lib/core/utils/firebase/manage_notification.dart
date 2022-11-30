import '../../../features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';

import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/driver_list_screen.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/requested_passengers_screen.dart';
import '../../../features/ride/presentation/providers/driver_ride_provider.dart';
import '../../../features/ride/presentation/providers/passenger_ride_provider.dart';
import '../../router/app_state.dart';
import '../../router/models/page_action.dart';
import '../../router/models/page_config.dart';
import '../enums/page_state_enum.dart';
import '../globals/globals.dart';

class ManageNotification {
  static AppState appState = sl();
  static AuthProvider authProvider = sl();

  //Drivers
  /// This method is to manage the request to driver notification
  static manageRequestNotification(Map<String, dynamic> data) {
    if (data['role'] != '1') {
      return;
    }
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isFromNewRideScreen = false;
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.requestedPassengersPageConfigs,
        widget: RequestedPassengersScreen(
          id: data['routeId'],
        ));
  }

  //*********************************************//

  //passengers

  /// This method is to manage accepted request notification to passenger
  static manageAcceptedRequestNotificaition(Map<String, dynamic> data) {
    if (data['role'] != '2') {
      return;
    }

    AppState appState = sl();
    appState.goToNext(PageConfigs.passengerSchedulesScreenPageConfig);
    // appState.currentAction = PageAction(
    //     state: PageState.addWidget,
    //     page: PageConfigs.driversListPageConfig,
    //     widget: DriverListScreen(
    //       id: data['scheduleId'],
    //     ));
  }

  static manageNewRequestByDriver(Map<String, dynamic> data) {

    AppState appState = sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.driversListPageConfig,
        widget: DriverListScreen(
          id: data['scheduleId'],
        ));
  }

  /// This is to manage the passenger notification when driver starts a ride
  static manageStartRideNotification(Map<String, dynamic> data) {
    if (data['role'] != '2') {
      return;
    }

    PassengerRideProvider passengerRideProvider = sl();
    passengerRideProvider.getAndSetCurrentRide(
        routeId: data['routeId'], scheduleId: data['scheduleId']);
  }

  ///This method to manage the passengers notification when driver updates status like arrived, on the way, started
  static managePassengerRideStatusNotification(Map<String, dynamic> data) {
    if (data['role'] != '2') {
      return;
    }
    PassengerRideProvider passengerRideProvider = sl();
    passengerRideProvider.getAndSetCurrentRide(
        routeId: data['routeId'], scheduleId: data['scheduleId']);
  }

  //when driver will add new route and his route is matched with the passenger route then this will come and will be managed here
  static manageNewMatchedDriverFoundNotification(Map<String, dynamic> data) {
    if (data['role'] != '2' ||
        authProvider.currentUser!.selectedUserType != '2') {
      return;
    }
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isFromNewRideScreen = false;
    AppState appState = sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.driversListPageConfig,
        widget: DriverListScreen(
          id: data['scheduleId'],
        ));
  }

  //when passenger will add new route and his route is matched with the driver route then this will come and will be managed here
  static manageNewMatchedPassengerFoundNotification(Map<String, dynamic> data) {
    // if (data['role'] != '1' ||
    //     authProvider.currentUser!.selectedUserType != '1') {
    //   return;
    // }
    ScheduleProvider scheduleProvider = sl();
    scheduleProvider.isFromNewRideScreen = false;
    AppState appState = sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.requestedPassengersPageConfigs,
        widget: RequestedPassengersScreen(
          id: data['routeId'],
        ));
  }

  static manageBlockUserNotification(Map<String, dynamic> data) {
    AuthProvider authProvider = sl();
    authProvider.getUserProfile();
  }

  static manageConfirmationByPassengerNotification(Map<String, dynamic> data) {
    if (authProvider.currentUser!.selectedUserType != '1') {
      return;
    }
    DriverRideProvider driverRideProvider = sl();

    driverRideProvider.getAndSetCurrentRide(data['routeId']);
  }
}

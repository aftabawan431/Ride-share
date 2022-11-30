import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/driver_list_screen.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/driver_schedules_screen.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/passenger_scdules_screen.dart';
import '../../../features/drawer_wrapper/schedules_driver/presentation/pages/requested_passengers_screen.dart';
import '../../../features/ride/presentation/pages/driver_ride_screen.dart';
import '../../../features/ride/presentation/pages/passenger_ride_screen.dart';

class SocketPoint {
  // passengers

  /// This emitter will input SocketId and output matched drivers list
  static const String matchDriversEmit =
      'matcheddrivers'; // input : scheduleId    // output : status + list // eror: status + error
  static const String rideRequestToDriverEmit =
      'rideRequest'; // input : scheduleId + route + id  // output : list + status
  /// in [DriverListScreen], to reject other driver route from matched driver list this endpoint will be used
  static const String rejectRequestOfDriverEmit =
      'rejectedRequestByPassenger'; // input : scheduleId + routeid  // output : list + status
  /// In [PassengerSchedulesScreen] to cancel the ride this endpoint will be used
  static const String cancelPassengerScheduleEmit =
      'cancelRequestByPassenger'; // input : scheduleId + routeid  // output : list + status
  /// In [PassengerRideScreen] to cancel the in ride  by passenger this point will be used
  static const String inRidePassengerScheduleEmit =
      'cancelInRideRequestByPassenger'; // input : scheduleId + routeid  // output : list + status
  static const String refreshEverything = 'refresh';

  /// In [PassengerSchedulesScreen] to delete a schedule by passenger this endpoint will be used
  static const String deteleSchedule = 'deteleSchedule';

  /// In [PassengerRideScreen] this listener will listen for driver live location update and by its out Car marker will be updated
  static const String driverLocationUpdatesOn = 'refreshLiveLocation';

  /// In [PassengerRideScreen] this listener for listen for passenger ride status like Arrived, On the way, Started.
  static const String updatePassengerRideStatus = 'updatePassengerRideStatus';

  /// Rhis listener will keep on listening for updates once driver starts ride, passenger will be redirected to the [PassengerRideScreen]
  static const String redirectPassengerToActiveRideListner =
      'redirectPassengerToActiveRide';

  static const String refreshPassengerScheduleListner = 'refreshSchedule';

  /// If passenger cancel his ride, then this listner will listen for updates
  static const String passengerRideCancellationListner =
      'passengerRideCancellationListener';

  /// It will get the active passenger ride and redirect user to the Passenger Ride Screen
  static const String passengerActiveRideEmitter = 'activeRide';
  static const String confirmStartRide = 'confirmStartRide';

  //drivers

  /// To start or continue ride by Driver
  static const String startContinueRideByDriver = 'start';

  /// it will listen for new request also when passenger will cancel the request
  static const String driverNewRequestOn = 'newRequest';

  /// This endpoint will be used to get updated requests in [RequestedPassengersScreen], Input: [routeId] Output : [GetRequestedPassengerResponseModel]
  static const String requestedPassengersEmit = 'getAllRequests';
  // static const String passengerCancelledRequestOn='cancelRequestByPassenger'; // refresh getAllRequests
  /// In [RequestedPassengersScreen] if passenger request is pending then Owner can reject the request using this endpoint
  static const String rejectRequestByDriver = 'rejectRequestByDriver';

  /// In [RequestedPassengersScreen] once driver has accepted the ride, then he can cancel it using this endpoint
  static const String cancelPassengerRideByDriver = 'cancelRequestByDriver';

  /// In [RequestedPassengersScreen] to accept a passenger request for ride, this end point will be used
  static const String acceptRequestByDriver = 'acceptRequest';
  /// In [RequestedPassengersScreen] to accept a passenger request for ride, this end point will be used
  static const String acceptRequestByPassenger = 'acceptRequestByPassenger';
  static const String updateDriverLocatin = 'liveLocation';

  /// In [DriverSchedulesScreen] to cancel the ride this endpoint will be used, It will cancel all rides of driver
  static const String cancelDriverRouteEmit = 'cancelRoute';

  /// In [DriverSchedulesScreen] to delete the ride this endpoint will be used, That route of Owner will be deleted softly
  static const String deleteDriverRouteEmit = 'deleteRoute';

  /// In [DriverSchedulesScreen] to finish the ride this endpoint will be used, This will change the status to finish then user can reshedule it
  static const String finishDriverActiveRideEmit = 'finishRide';
  // static const String cancelDriverRideEmit='liveLocation';

  // update passenger ride status emitters
  /// To update the status of Passenger ride to OnTheWay in [DriverRideScreen].
  static const String onTheWayEmitter = 'onTheWay';

  /// To update the status of Passenger ride to Started in [DriverRideScreen].
  static const String arrivedEmitter = 'arrived';

  /// To update the status of Passenger ride to Arrived in [DriverRideScreen].
  static const String startRideEmitter = 'startRide';

  /// To update the status of Passenger ride to Complete Ride in [DriverRideScreen].
  static const String completeRideEmitter = 'completeRide';

  //inride
  /// WHen driver will be in Driver Ride (Map) screen [DriverRideScreen], to accept request in driver ride screen this end point will be used
  static const String acceptInRideRequestEmit = 'acceptInRideRequest';

  /// WHen driver will be in Driver Ride (Map) screen [DriverRideScreen], to reject request in driver ride screen this end point will be used
  static const String rejectInRideRequestEmit = 'rejectInRideRequest';

  /// WHen driver will be in Driver Ride (Map) screen [DriverRideScreen], this listener will listen for new upcoming in ride requests.
  /// if there will be already pending requests then user will also first see those pending rides' requests

  static const String inRideRequestListener = 'inRideRequest';

  static const String rideConfirmationByPassengerListener =
      'rideConfirmByPassenger';

  ///WHen driver will be in Driver Ride (Map) screen [DriverRideScreen], to cancel the passenger request, this end point will be used
  static const String cancelInRidePassengerRequestByDriver =
      'cancelInRidePassengerRequestByDriver';

  /// to send request to passenger by driver
  static const String sendRequestToPassengerByDriver = 'sendRequestToPassenger';

  /// to reject request of passenger by driver
  static const String rejectRequestOfPassengerByDriver = '';

  // generic

  /// This is generitc
  // TODO: Enc pending by backend
  static const String errorListner = 'error';

  //chats

  static const String newMessageListner = 'newMessageReceived';

  static const String joinRoomAndGetMessagesEmitter =
      'chat'; // input sender , receiver, output all previous chats
  static const String leaveRoomEmitter =
      'leaveChatRoom'; // input: sender, receiver

  /// It will send message to the point
  static const String sendMessageEmitter = 'sendMessage';

  /// It will listen for new messages on chat's screen
  static const String newMessageListener = 'newMessage';

  /// It
  static const String deviceUpdatesListener = 'deviceUpdate';

  // others
  /// To refresh stats like Total Rides, Cancelled Rides etc on Dashboard Screen
  static const String refreshDashboardListner = 'refreshDashboard';
}

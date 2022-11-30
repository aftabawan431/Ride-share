import 'package:dartz/dartz.dart';
import '../../../history/model/get_driver_history_response_model.dart';
import '../../../history/model/get_history_request_model.dart';
import '../../../history/model/get_history_response_model.dart';
import '../../../history/presentation/pages/history_screen.dart';
import '../../../notification/data/models/get_notifications_response_model.dart';
import '../../../notification/presentation/pages/notification_screen.dart';
import '../../data/models/get_drivers_list_request_model.dart';
import '../../data/models/get_drivers_list_response_model.dart';
import '../../data/models/get_passenger_schdules_response_model.dart';
import '../../data/models/get_requested_passenger_request_model.dart';
import '../../data/models/get_requested_passenger_response_model.dart';
import '../../data/models/get_schedules_requests_model.dart';
import '../../data/models/get_driver_schedules_response_model.dart';
import '../../data/models/reschdule_passenger_schedule_request_model.dart';
import '../../data/models/reshedule_driver_route_request_model.dart';
import '../../presentation/pages/driver_schedules_screen.dart';
import '../../presentation/pages/passenger_scdules_screen.dart';
import '../../presentation/pages/requested_passengers_screen.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/no_params.dart';
import '../../data/models/reshedule_response_model.dart';

abstract class DrawerWrapperRepository {
  /// On [DriverSchedulesScreen] to get list of dirvers rides/schedules
  Future<Either<Failure, GetDriverSchedulesResponseModel>> getDriverSchedules(
      GetSchedulesRequestModel params);

  /// On [DriverListScreen] passenger side to get list of matched drivers
  Future<Either<Failure, GetDriversListResponseModel>> getDriversList(
      GetDriversListRequestModel params);

  /// On [NotificationScreen] to get list of system notifications
  Future<Either<Failure, GetNotificationsResponseModel>> getNotifications(
      NoParams params);

  /// On [PassengerSchedulesScreen] to get list of passenger schedules
  Future<Either<Failure, GetPassengerSchdulesResponseModel>>
      getPassengerSchdules(GetSchedulesRequestModel params);

  /// On [RequestedPassengersScreen] to show list of request to the driver
  Future<Either<Failure, GetRequestedPassengerResponseModel>>
      getRequestedPassengers(GetRequestedPassengersRequestModel params);

  /// On [HistoryScreen] to show all history rides for both driver and passengers
  Future<Either<Failure, GetHistoryResponseModel>> getHistory(
      GetHistoryRequestModel params);

  /// On [HistoryScreen] to show all history rides for both driver and passengers
  Future<Either<Failure, GetDriverHistoryResponseModel>> getDriverHistory(
      GetHistoryRequestModel params);

  /// On [DriverSchedulesScreen] to reshdule the route if route is cancelled or finished
  Future<Either<Failure, RescheduleResponseModel>> rescheduleDriverRoute(
      RescheduleDriverRouteRequestModel params);

  /// On [PassengerSchedulesScreen] to reshdule the route if route is cancelled or finished
  Future<Either<Failure, RescheduleResponseModel>> reschedulePassengerSchedule(
      ReschedulePassengerScheduleRequestModel params);
}

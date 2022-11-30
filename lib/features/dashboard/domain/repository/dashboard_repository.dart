
import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../../data/model/GetVehicleCapacityRequestModel.dart';
import '../../data/model/add_passenger_schedule_request_model.dart';
import '../../data/model/add_rating_request_model.dart';
import '../../data/model/add_rating_response_model.dart';
import '../../data/model/add_ride_request_response_model.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../../data/model/get_vehicle_capacity_response_model.dart';
import '../../data/model/switch_role_request_model.dart';
import '../../presentation/widgets/dashboard_ride_history_widget.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/add_driver_route_request_model.dart';
import '../../data/model/get_dashboard_history_rides_request_model.dart';

abstract class DashboardRepository {

  Future<Either<Failure, AddDriverRideResponseModel>> addDriverRequest(AddDriverRouteRequestModel params);
  Future<Either<Failure, AddDriverRideResponseModel>> addPassengerRequest(AddPassengerScheduleRequestModel params);
  Future<Either<Failure, AddRatingResponseModel>> addRating(AddRatingRequestModel params);
  Future<Either<Failure, GetDashboardDataResponseModel>> getDashboardData(NoParams params);
  Future<Either<Failure, DashboardRideHistoryReponseModel>> getHistoryRides(GetDashboardHistoryRidesRequestModel params);
  Future<Either<Failure, GetVehicleCapacityResponseModel>> getVehicleCapacity(GetVehicleCapacityRequestModel params);
  Future<Either<Failure, LoginResponseModel>> switchRole(SwitchRoleRequestModel params);





}

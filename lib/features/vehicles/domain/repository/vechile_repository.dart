import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../data/models/add_vehicle_request_model.dart';
import '../../data/models/add_vehicle_response_model.dart';
import '../../data/models/delete_vehicle_request_model.dart';
import '../../data/models/get_city_request_model.dart';
import '../../data/models/get_city_response_model.dart';
import '../../data/models/get_models_request_model.dart';
import '../../data/models/get_models_response_model.dart';
import '../../data/models/get_user_vehicles_request_model.dart';
import '../../data/models/get_user_vehicles_response_model.dart';
import '../../data/models/get_vehicle_initials_response.dart';
import '../../presentation/pages/vechicle_management.dart';
import '../../presentation/pages/vehicle_details_screen.dart';


import '../../../../../core/error/failures.dart';


abstract class VehicleRepository {

  /// ON [VehicleDetailsScreen] to get initial default dropdowns
  Future<Either<Failure, GetVehicleInitialsResponseModel>> getInitials(NoParams params);
  /// On [VehicleDetailsScreen] to get city from province
  Future<Either<Failure, GetCityResponseModel>> getCity(GetCityRequestModel params);
  /// On [VehicleDetailsScreen] to get vehicle model from vehicle type and vihicle maker
  Future<Either<Failure, GetModelsResponseModel>> getModel(GetModelsRequestModel params);
  /// On [VehicleDetailsScreen] to add new vehicle
  Future<Either<Failure, AddVehicleResponseModel>> addVehicle(AddVehicleRequestModel params);
  /// On [VehicleManagementScreen] to delete vehicle from list
  Future<Either<Failure, GetUserVehiclesResponseModel>> deleteVehicle(DeleteVehicleRequestModel params);
  /// On [VehicleManagementScreen] to get list of user vehicles
  Future<Either<Failure, GetUserVehiclesResponseModel>> getVehicles(GetUserVehicleRequestModel params);




}

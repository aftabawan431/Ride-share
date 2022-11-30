import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../datasouces/dashboard_remote_datasource.dart';
import '../model/GetVehicleCapacityRequestModel.dart';
import '../model/add_passenger_schedule_request_model.dart';
import '../model/add_rating_response_model.dart';
import '../model/add_ride_request_response_model.dart';
import '../model/dashboard_data_response_model.dart';
import '../model/get_dashboard_history_rides_request_model.dart';
import '../model/get_vehicle_capacity_response_model.dart';
import '../model/switch_role_request_model.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../../presentation/widgets/dashboard_ride_history_widget.dart';



import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/network/network_info.dart';
import '../model/add_driver_route_request_model.dart';
import '../model/add_rating_request_model.dart';


class DashboardRepoImp implements DashboardRepository {
  final NetworkInfo networkInfo;

  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AddDriverRideResponseModel>> addDriverRequest(
      AddDriverRouteRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.addDriverRequest(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
  @override
  Future<Either<Failure, AddDriverRideResponseModel>> addPassengerRequest(
      AddPassengerScheduleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.addPassengerRequest(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }
  @override
  Future<Either<Failure, AddRatingResponseModel>> addRating(
      AddRatingRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.addRating(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> switchRole(
      SwitchRoleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.switchRole(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }


  @override
  Future<Either<Failure, GetDashboardDataResponseModel>> getDashboardData(
      NoParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDashboardData(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }

  @override
  Future<Either<Failure, GetVehicleCapacityResponseModel>> getVehicleCapacity(
      GetVehicleCapacityRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getVehicleCapacity(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }

  @override
  Future<Either<Failure, DashboardRideHistoryReponseModel>> getHistoryRides(
      GetDashboardHistoryRidesRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDashboardHistoryRides(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));

    }
  }







}

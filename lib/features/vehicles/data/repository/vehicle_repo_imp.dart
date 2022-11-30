import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';

import '../data_sources/vehicle_data_source.dart';
import '../models/add_vehicle_request_model.dart';
import '../models/delete_vehicle_request_model.dart';
import '../models/get_city_request_model.dart';
import '../models/get_city_response_model.dart';
import '../models/get_models_response_model.dart';
import '../models/get_user_vehicles_request_model.dart';
import '../models/get_user_vehicles_response_model.dart';
import '../models/get_vehicle_initials_response.dart';
import '../../domain/repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/network/network_info.dart';
import '../models/add_vehicle_response_model.dart';
import '../models/get_models_request_model.dart';

class VehicleRepoImp implements VehicleRepository {
  final NetworkInfo networkInfo;

  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GetVehicleInitialsResponseModel>> getInitials(
      NoParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getInitials(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetCityResponseModel>> getCity(
      GetCityRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getCity(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetModelsResponseModel>> getModel(
      GetModelsRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getModel(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, AddVehicleResponseModel>> addVehicle(
      AddVehicleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.addVehicle(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetUserVehiclesResponseModel>> getVehicles(
      GetUserVehicleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getVehicles(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetUserVehiclesResponseModel>> deleteVehicle(
      DeleteVehicleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.deleteVehicle(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}

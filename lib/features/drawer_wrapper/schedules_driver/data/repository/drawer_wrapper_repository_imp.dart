import 'package:dartz/dartz.dart';
import '../../../../../core/modals/no_params.dart';

import '../../../history/model/get_driver_history_response_model.dart';
import '../../../history/model/get_history_request_model.dart';
import '../../../history/model/get_history_response_model.dart';
import '../../../notification/data/models/get_notifications_response_model.dart';
import '../data_souce/drawer_wrapper_remote_datasouce.dart';
import '../models/get_drivers_list_request_model.dart';
import '../models/get_drivers_list_response_model.dart';
import '../models/get_passenger_schdules_response_model.dart';
import '../models/get_requested_passenger_request_model.dart';
import '../models/get_requested_passenger_response_model.dart';
import '../models/get_schedules_requests_model.dart';
import '../models/get_driver_schedules_response_model.dart';
import '../models/reshedule_driver_route_request_model.dart';
import '../../domain/repository/drawer_wrapper_repository.dart';


import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/network/network_info.dart';
import '../models/reschdule_passenger_schedule_request_model.dart';
import '../models/reshedule_response_model.dart';


class DrawerWrapperRepoImp implements DrawerWrapperRepository {
  final NetworkInfo networkInfo;

  final DrawerWrapperRemoteDatasource remoteDataSource;

  DrawerWrapperRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GetDriverSchedulesResponseModel>> getDriverSchedules(
      GetSchedulesRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDriverSchedules(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
  @override
  Future<Either<Failure, GetPassengerSchdulesResponseModel>> getPassengerSchdules(
      GetSchedulesRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getPassengerSchedules(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
  @override
  Future<Either<Failure, GetDriversListResponseModel>> getDriversList(
      GetDriversListRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDriversList(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetRequestedPassengerResponseModel>> getRequestedPassengers(
      GetRequestedPassengersRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getRequestedPassengers(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetHistoryResponseModel>> getHistory(
      GetHistoryRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getHistory(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetDriverHistoryResponseModel>> getDriverHistory(
      GetHistoryRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getDriverHistory(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetNotificationsResponseModel>> getNotifications(
      NoParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getNotifications(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, RescheduleResponseModel>> rescheduleDriverRoute(
      RescheduleDriverRouteRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.rescheduleDriverRoute(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }


  @override
  Future<Either<Failure, RescheduleResponseModel>> reschedulePassengerSchedule(
      ReschedulePassengerScheduleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.reschedulePassengerSchedule(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }







}

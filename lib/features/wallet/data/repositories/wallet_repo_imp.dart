import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/create_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/validate_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/zindigi_wallet_otp.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/network/network_info.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../data_sources/wallet_remote_data_source.dart';
import '../models/get_wallet_info_request_model.dart';
import '../models/get_wallet_info_response_model.dart';
import '../models/unlink_zindigi_account_request_model.dart';

class WalletRepoImp implements WalletRepository {
  final NetworkInfo networkInfo;

  final WalletRemoteDataSource remoteDataSource;

  WalletRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, GetWalletInfoResponseModel>> getWalletInfo(
      GetWalletInfoRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getWalletInfo(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, SuccessResponseModel>> linkZindigiAccount(
      LinkZindigiAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.linkZindigiAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }  @override
  Future<Either<Failure, SuccessResponseModel>> validateZindigiAccount(
      ValidateZindigiAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.validateZindigiAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, SuccessResponseModel>> createZindigiAccount(
      CreateZindigiAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.createZindigiAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, SuccessResponseModel>> unlinkZindigiAccount(
      UnlinkZindigiAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.unlinkZindigiAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }  @override
  Future<Either<Failure, SuccessResponseModel>> zindigiWalletOtp(
      ZindigWalletOtpRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.zindigiWalletOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}
import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/no_params.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/change_number_available_check_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_user_profile_request_model.dart';
import '../../../../../core/modals/success_response_model.dart';
import '../data_sources/auth_data_source.dart';
import '../models/delete_account_request_model.dart';
import '../models/delete_account_response_model.dart';
import '../models/email_verify_request_model.dart';
import '../models/find_account_request_model.dart';
import '../models/find_account_respnose_model.dart';
import '../models/logout_request_model.dart';
import '../models/logout_response_model.dart';
import '../models/mobile_verify_request_model.dart';
import '../models/otp_verify_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/resend_otp_response_model.dart';
import '../models/reset_password_response_model.dart';
import '../models/update_mobile_number_request_model.dart';
import '../models/update_selected_vehicle_request_model.dart';
import '../models/update_selected_vehicle_response_model.dart';
import '../../domain/repository/auth_repo.dart';
import '../../../document_verification/models/driver_document_upload_response_model.dart';
import '../../../../drawer_wrapper/profile/data/model/add_profile_image_request_model.dart';
import '../../../../drawer_wrapper/profile/data/model/update_profile_request_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/network/network_info.dart';
import '../../../auth_wrapper/data/models/login_response_modal.dart';
import '../../../auth_wrapper/data/models/login_request_model.dart';
import '../../../document_verification/models/driver_document_upload_request_model.dart';
import '../models/reset_password_request_model.dart';

class AuthRepoImp implements AuthRepository {
  final NetworkInfo networkInfo;

  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImp({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LoginResponseModel>> loginUser(
      LoginRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.loginUser(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> registerUser(
      RegisterRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.registerUser(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, OtpVerifyResponseModel>> verifyEmail(
      EmailVerifyRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.verifyEmail(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, OtpVerifyResponseModel>> verifyPhone(
      MobileVerifyRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.verifyMobile(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> updateProfileImage(
      AddProfileImageRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.updateProfileImage(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> updateProfile(
      UpdateProfileRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.updateProfile(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, UpdateSelectedVehicleResponseModel>>
      updateSelectedVehicle(UpdateSelectedVehicleRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.updateSelectedVehicle(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, ResendOtpResponseModel>> resendOtp(
      ResendOtpRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.resendOtp(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, FindAccountResponseModel>> findAccount(
      FindAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.findAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, ResetPasswordResposeModel>> resetPassword(
      ResetPasswordRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.resetPassword(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, LogoutResponseModel>> logoutUser(
      LogoutRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.logoutUser(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, DriverDocumentUploadResponseModel>>
      driverDocumentUpload(DriverDocumentUploadRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.driverDocumentUpload(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount(
      DeleteAccountRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.deleteAccount(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, SuccessResponseModel>> newNumberAvailbleCheck(
      NewNumberAvailableCheckRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.newNumberAvailbleCheck(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> updateMobileNumber(
      UpdateMobileNumberRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.updateMobileNumber(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, GetSimProvidersResponseModel>> getSimProviders(
      NoParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getSimProviders(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> getUserProfile(
      GetUserProfileRequestModel params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await remoteDataSource.getUserProfile(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}

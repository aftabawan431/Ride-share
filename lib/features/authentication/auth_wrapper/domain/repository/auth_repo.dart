import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/no_params.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/change_number_available_check_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/success_response_model.dart';
import '../../../../drawer_wrapper/profile/data/model/add_profile_image_request_model.dart';
import '../../../../drawer_wrapper/profile/data/model/update_profile_request_model.dart';
import '../../../auth_wrapper/data/models/login_request_model.dart';
import '../../../auth_wrapper/data/models/login_response_modal.dart';
import '../../../document_verification/models/driver_document_upload_request_model.dart';
import '../../../document_verification/models/driver_document_upload_response_model.dart';
import '../../data/models/delete_account_request_model.dart';
import '../../data/models/delete_account_response_model.dart';
import '../../data/models/email_verify_request_model.dart';
import '../../data/models/find_account_request_model.dart';
import '../../data/models/find_account_respnose_model.dart';
import '../../data/models/get_user_profile_request_model.dart';
import '../../data/models/logout_request_model.dart';
import '../../data/models/logout_response_model.dart';
import '../../data/models/mobile_verify_request_model.dart';
import '../../data/models/otp_verify_response_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/resend_otp_request_model.dart';
import '../../data/models/resend_otp_response_model.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../data/models/reset_password_response_model.dart';
import '../../data/models/update_mobile_number_request_model.dart';
import '../../data/models/update_selected_vehicle_request_model.dart';
import '../../data/models/update_selected_vehicle_response_model.dart';

abstract class AuthRepository {

  Future<Either<Failure, LoginResponseModel>> loginUser(
      LoginRequestModel params);
  Future<Either<Failure, ResetPasswordResposeModel>> resetPassword(
      ResetPasswordRequestModel params);
  Future<Either<Failure, FindAccountResponseModel>> findAccount(
      FindAccountRequestModel params);
  Future<Either<Failure, DriverDocumentUploadResponseModel>>
      driverDocumentUpload(DriverDocumentUploadRequestModel params);

  Future<Either<Failure, RegisterResponseModel>> registerUser(
      RegisterRequestModel params);
  Future<Either<Failure, LogoutResponseModel>> logoutUser(
      LogoutRequestModel params);

  Future<Either<Failure, OtpVerifyResponseModel>> verifyEmail(
      EmailVerifyRequestModel params);
  Future<Either<Failure, ResendOtpResponseModel>> resendOtp(
      ResendOtpRequestModel params);
  Future<Either<Failure, OtpVerifyResponseModel>> verifyPhone(
      MobileVerifyRequestModel params);
  Future<Either<Failure, LoginResponseModel>> updateProfileImage(
      AddProfileImageRequestModel params);
  Future<Either<Failure, LoginResponseModel>> updateProfile(
      UpdateProfileRequestModel params);
  Future<Either<Failure, UpdateSelectedVehicleResponseModel>>
      updateSelectedVehicle(UpdateSelectedVehicleRequestModel params);
  Future<Either<Failure, DeleteAccountResponseModel>> deleteAccount(
      DeleteAccountRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> newNumberAvailbleCheck(
      NewNumberAvailableCheckRequestModel params);

  Future<Either<Failure, LoginResponseModel>> updateMobileNumber(
      UpdateMobileNumberRequestModel params);

  Future<Either<Failure, GetSimProvidersResponseModel>> getSimProviders(
      NoParams params);

  Future<Either<Failure, LoginResponseModel>> getUserProfile(
      GetUserProfileRequestModel params);
}

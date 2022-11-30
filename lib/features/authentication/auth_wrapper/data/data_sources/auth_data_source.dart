import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_rideshare/core/modals/no_params.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/change_number_available_check_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_user_profile_request_model.dart';
import 'package:logger/logger.dart';
import '../../../../../core/modals/success_response_model.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../models/delete_account_request_model.dart';
import '../models/email_verify_request_model.dart';
import '../models/find_account_request_model.dart';
import '../models/logout_response_model.dart';
import '../models/mobile_verify_request_model.dart';
import '../models/otp_verify_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/resend_otp_request_model.dart';
import '../models/resend_otp_response_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/reset_password_response_model.dart';
import '../models/update_mobile_number_request_model.dart';
import '../models/update_selected_vehicle_request_model.dart';
import '../models/update_selected_vehicle_response_model.dart';
import '../../../document_verification/models/driver_document_upload_request_model.dart';
import '../../../document_verification/models/driver_document_upload_response_model.dart';
import '../../../../drawer_wrapper/profile/data/model/add_profile_image_request_model.dart';
import '../../../../drawer_wrapper/profile/data/model/update_profile_request_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/error_response_model.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/encryption/encryption.dart';
import '../models/delete_account_response_model.dart';
import '../models/find_account_respnose_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_modal.dart';
import '../models/logout_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> loginUser(LoginRequestModel params);
  Future<RegisterResponseModel> registerUser(RegisterRequestModel params);

  Future<OtpVerifyResponseModel> verifyEmail(EmailVerifyRequestModel params);

  Future<OtpVerifyResponseModel> verifyMobile(MobileVerifyRequestModel params);

  Future<LoginResponseModel> updateProfileImage(
      AddProfileImageRequestModel params);

  Future<LoginResponseModel> updateProfile(UpdateProfileRequestModel params);

  Future<UpdateSelectedVehicleResponseModel> updateSelectedVehicle(
      UpdateSelectedVehicleRequestModel params);

  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel params);

  Future<FindAccountResponseModel> findAccount(FindAccountRequestModel params);

  Future<ResetPasswordResposeModel> resetPassword(
      ResetPasswordRequestModel params);
  Future<LogoutResponseModel> logoutUser(LogoutRequestModel params);
  Future<DriverDocumentUploadResponseModel> driverDocumentUpload(
      DriverDocumentUploadRequestModel params);
  Future<DeleteAccountResponseModel> deleteAccount(
      DeleteAccountRequestModel params);

  Future<SuccessResponseModel> newNumberAvailbleCheck(
      NewNumberAvailableCheckRequestModel params);

  Future<LoginResponseModel> updateMobileNumber(
      UpdateMobileNumberRequestModel params);

  Future<GetSimProvidersResponseModel> getSimProviders(NoParams params);
  Future<LoginResponseModel> getUserProfile(GetUserProfileRequestModel params);
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  Dio dio;
  AuthRemoteDataSourceImp({required this.dio});

  @override
  Future<LoginResponseModel> loginUser(LoginRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.loginUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));


      final response = await dio.post(url, data: encryptedParams);
      Logger().v(response.data);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        Logger().v(response.data);
        return LoginResponseModel.fromJson(decryptedJson);
      }

      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      // Logger().v(exception.response!.statusCode);
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      print('error here');
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<RegisterResponseModel> registerUser(
      RegisterRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.registerUrl;

    try {

      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      Logger().v(response.data);

      if (response.statusCode == 201) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return RegisterResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<OtpVerifyResponseModel> verifyEmail(
      EmailVerifyRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.valiteEmailOtpUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 202) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return OtpVerifyResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<OtpVerifyResponseModel> verifyMobile(
      MobileVerifyRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.validatePhoneUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 202) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return OtpVerifyResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<LoginResponseModel> updateProfileImage(
      AddProfileImageRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.updateProfileImageUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return LoginResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<LoginResponseModel> updateProfile(
      UpdateProfileRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.updateProfileUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return LoginResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<UpdateSelectedVehicleResponseModel> updateSelectedVehicle(
      UpdateSelectedVehicleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.updateSelectedVehicle;
    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return UpdateSelectedVehicleResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.resendOtpUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.put(url, data: encryptedParams);
      if (response.statusCode == 204) {
        return ResendOtpResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<FindAccountResponseModel> findAccount(
      FindAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.findAccountUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        return FindAccountResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<ResetPasswordResposeModel> resetPassword(
      ResetPasswordRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.resetPasswordUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        return ResetPasswordResposeModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<LogoutResponseModel> logoutUser(LogoutRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.logoutUserUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        return LogoutResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<DriverDocumentUploadResponseModel> driverDocumentUpload(
      DriverDocumentUploadRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.driverDocumentUploadUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        return DriverDocumentUploadResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<DeleteAccountResponseModel> deleteAccount(
      DeleteAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.deleteAccountUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.delete(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedResponse = Encryption.decryptJson(response.data);

        return DeleteAccountResponseModel.fromJson(decryptedResponse);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<SuccessResponseModel> newNumberAvailbleCheck(
      NewNumberAvailableCheckRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.newNumberAvailbleCheckUrl;
    Logger().v(url);
    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      Logger().v(params.toJson());

      final response = await dio.post(url, data: params.toJson());
      if (response.statusCode == 200) {
        // final decryptedResponse = Encryption.decryptJson(response.data);

        return SuccessResponseModel.fromJson(response.data);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<LoginResponseModel> updateMobileNumber(
      UpdateMobileNumberRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.updateMobileNumberUrl;
    Logger().v(url);
    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      Logger().v(params.toJson());

      final response = await dio.put(url, data: params.toJson());
      if (response.statusCode == 200) {
        // final decryptedResponse = Encryption.decryptJson(response.data);

        return LoginResponseModel.fromJson(response.data);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }

  @override
  Future<GetSimProvidersResponseModel> getSimProviders(NoParams params) async {
    String url = AppUrl.baseUrl + AppUrl.getSimProvidersUrl;
    Logger().v(url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decryptedResponse = Encryption.decryptJson(response.data);

        return GetSimProvidersResponseModel.fromJson(decryptedResponse);
        // return GetSimProvidersResponseModel.fromJson(decryptedResponse);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }


  @override
  Future<LoginResponseModel> getUserProfile(
      GetUserProfileRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getUserProfileUrl;
    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedResponse = Encryption.decryptJson(response.data);
        return LoginResponseModel.fromJson(decryptedResponse);
        // return GetSimProvidersResponseModel.fromJson(decryptedResponse);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e.toString());
    }
  }
}

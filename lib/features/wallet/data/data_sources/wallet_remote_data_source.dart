import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/create_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/unlink_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/validate_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/zindigi_wallet_otp.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/modals/error_response_model.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/utils/encryption/encryption.dart';
import '../../../../core/utils/globals/globals.dart';

abstract class WalletRemoteDataSource {
  Future<GetWalletInfoResponseModel> getWalletInfo(
      GetWalletInfoRequestModel params);

  Future<SuccessResponseModel> linkZindigiAccount(
      LinkZindigiAccountRequestModel params);

  Future<SuccessResponseModel> validateZindigiAccount(
      ValidateZindigiAccountRequestModel params);

  Future<SuccessResponseModel> createZindigiAccount(
      CreateZindigiAccountRequestModel params);

  Future<SuccessResponseModel> unlinkZindigiAccount(
      UnlinkZindigiAccountRequestModel params);

  Future<SuccessResponseModel> zindigiWalletOtp(
      ZindigWalletOtpRequestModel params);
}

class WalletRemoteDataSourceImp implements WalletRemoteDataSource {
  Dio dio;
  WalletRemoteDataSourceImp({required this.dio});

  @override
  Future<GetWalletInfoResponseModel> getWalletInfo(
      GetWalletInfoRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getWalletInfoUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        Logger().v(decryptedJson);
        return GetWalletInfoResponseModel.fromJson(decryptedJson);
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
      throw SomethingWentWrong(e);
    }
  }

  @override
  @override
  Future<SuccessResponseModel> validateZindigiAccount(
      ValidateZindigiAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.validateZindigiAccountUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        Logger().v(decryptedJson);
        return SuccessResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        kStatusCode = exception.response!.statusCode!;
        ErrorResponseModel errorResponseModel =

            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<SuccessResponseModel> linkZindigiAccount(
      LinkZindigiAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.linkZindigiAccountUrl;
    Logger().v(params.toJson());

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);


      if (response.statusCode == 200) {

        final decryptedJson = Encryption.decryptJson(response.data);
        return SuccessResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {

      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        Logger().v(exception.response!.statusCode);
        final decryptedResponse=Encryption.decryptJson(exception.response?.data);
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(decryptedResponse);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<SuccessResponseModel> createZindigiAccount(
      CreateZindigiAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.createZindigiAccountUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      Logger().v(params.toJson());
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        return SuccessResponseModel.fromJson(decryptedJson);
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
      throw SomethingWentWrong(e);
    }
  }


  @override
  Future<SuccessResponseModel> unlinkZindigiAccount(
      UnlinkZindigiAccountRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.unlinkZindigiAccount;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      Logger().v(params.toJson());
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        return SuccessResponseModel.fromJson(decryptedJson);
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
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<SuccessResponseModel> zindigiWalletOtp(
      ZindigWalletOtpRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.zindigiWalletOtp;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));
      Logger().v(params.toJson());
      final response = await dio.post(url, data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        return SuccessResponseModel.fromJson(decryptedJson);
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
      throw SomethingWentWrong(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/modals/no_params.dart';
import '../models/add_vehicle_request_model.dart';
import '../models/add_vehicle_response_model.dart';
import '../models/delete_vehicle_request_model.dart';
import '../models/get_city_request_model.dart';
import '../models/get_city_response_model.dart';
import '../models/get_models_request_model.dart';
import '../models/get_models_response_model.dart';
import '../models/get_user_vehicles_request_model.dart';
import '../models/get_user_vehicles_response_model.dart';
import '../models/get_vehicle_initials_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/error_response_model.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/encryption/encryption.dart';

abstract class VehicleRemoteDataSource {
  Future<GetVehicleInitialsResponseModel> getInitials(NoParams params);
  Future<GetCityResponseModel> getCity(GetCityRequestModel params);
  Future<GetModelsResponseModel> getModel(GetModelsRequestModel params);
  Future<AddVehicleResponseModel> addVehicle(AddVehicleRequestModel params);
  Future<GetUserVehiclesResponseModel> getVehicles(
      GetUserVehicleRequestModel params);
  Future<GetUserVehiclesResponseModel> deleteVehicle(
      DeleteVehicleRequestModel params);
}

class VehicleRemoteDataSourceImp implements VehicleRemoteDataSource {
  Dio dio;
  VehicleRemoteDataSourceImp({required this.dio});

  @override
  Future<GetVehicleInitialsResponseModel> getInitials(NoParams params) async {
    String url = AppUrl.baseUrl + AppUrl.getVehicleInitials;

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return GetVehicleInitialsResponseModel.fromJson(decryptedJson);
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
  Future<GetCityResponseModel> getCity(GetCityRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getCityFromProviceUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return GetCityResponseModel.fromJson(decryptedJson);
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
  Future<GetModelsResponseModel> getModel(GetModelsRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getModelsFromMakerUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return GetModelsResponseModel.fromJson(decryptedJson);
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
  Future<AddVehicleResponseModel> addVehicle(
      AddVehicleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.addVehicleUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 201) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return AddVehicleResponseModel.fromJson(decryptedJson);
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
  Future<GetUserVehiclesResponseModel> getVehicles(
      GetUserVehicleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getVehiclesUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return GetUserVehiclesResponseModel.fromJson(decryptedJson);
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
  Future<GetUserVehiclesResponseModel> deleteVehicle(
      DeleteVehicleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.deleteVehicleUrl;
    final encryptedParams =
    Encryption.encryptObject(jsonEncode(params.toJson()));

    try {
      final response = await dio.put(url, data: encryptedParams);

      if (response.statusCode == 200) {


        final decryptedJson = Encryption.decryptJson(response.data);

        return GetUserVehiclesResponseModel.fromJson(decryptedJson);
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

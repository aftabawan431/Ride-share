import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/globals/snake_bar.dart';
import '../../../../core/modals/no_params.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../model/GetVehicleCapacityRequestModel.dart';
import '../model/add_passenger_schedule_request_model.dart';
import '../model/add_rating_request_model.dart';
import '../model/add_rating_response_model.dart';
import '../model/add_ride_request_response_model.dart';
import '../model/dashboard_data_response_model.dart';
import '../model/get_vehicle_capacity_response_model.dart';
import '../model/switch_role_request_model.dart';
import '../../presentation/providers/driver_dashboard_provider.dart';
import '../../presentation/widgets/dashboard_ride_history_widget.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/error_response_model.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/encryption/encryption.dart';
import '../../../../core/utils/globals/globals.dart';
import '../model/add_driver_route_request_model.dart';
import '../model/get_dashboard_history_rides_request_model.dart';

abstract class DashboardRemoteDataSource {
  Future<AddDriverRideResponseModel> addDriverRequest(
      AddDriverRouteRequestModel params);
  Future<AddDriverRideResponseModel> addPassengerRequest(
      AddPassengerScheduleRequestModel params);
  Future<AddRatingResponseModel> addRating(AddRatingRequestModel params);
  Future<LoginResponseModel> switchRole(SwitchRoleRequestModel params);
  Future<GetDashboardDataResponseModel> getDashboardData(NoParams params);
  Future<GetVehicleCapacityResponseModel> getVehicleCapacity(
      GetVehicleCapacityRequestModel params);
  Future<DashboardRideHistoryReponseModel> getDashboardHistoryRides(
      GetDashboardHistoryRidesRequestModel params);
}

class DashboardRemoteDataSourceImp implements DashboardRemoteDataSource {
  Dio dio;
  DashboardRemoteDataSourceImp({required this.dio});

  @override
  Future<AddDriverRideResponseModel> addDriverRequest(
      AddDriverRouteRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.addDriverRideRequestUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 201) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return AddDriverRideResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        DashboardProvider provider = sl();
        provider.responseStatusCode = exception.response!.statusCode;
        print('this is the status code ${exception.response!.statusCode}');

        ErrorResponseModel errorResponseModel =
        ErrorResponseModel.fromJson(exception.response?.data);
        print('this is the statusMessage  ${errorResponseModel.msg}');
        Loading.dismiss();
        ShowSnackBar.show(errorResponseModel.msg.toString());
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<AddDriverRideResponseModel> addPassengerRequest(
      AddPassengerScheduleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.addPassengerRideRequestUrl;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 201) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return AddDriverRideResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      if (exception.type == DioErrorType.connectTimeout) {
        throw TimeoutException(AppMessages.timeOut);
      } else {
        DashboardProvider provider = sl();
     print('this is the status code ${exception.response!.statusCode}');

    provider.responseStatusCode = exception.response!.statusCode;
        // provider.responseStatusMessage = exception.response!.data['msg'];

        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        print('this is the statusMessage  ${errorResponseModel.msg}');
        Loading.dismiss();
        ShowSnackBar.show(errorResponseModel.msg.toString());
        throw SomethingWentWrong(errorResponseModel.msg);

      }
    } catch (e) {
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<AddRatingResponseModel> addRating(AddRatingRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.addRating;

    try {
      final encryptedParams =
          Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url, data: encryptedParams);

      if (response.statusCode == 200) {
        return AddRatingResponseModel();
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
  Future<LoginResponseModel> switchRole(SwitchRoleRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.switchRoleUrl;

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
        DashboardProvider dashboardProvider = sl();
        dashboardProvider.responseStatusCode = exception.response!.statusCode;
        ErrorResponseModel errorResponseModel =
            ErrorResponseModel.fromJson(exception.response?.data);
        throw SomethingWentWrong(errorResponseModel.msg);
      }
    } catch (e) {
      throw SomethingWentWrong(e);
    }
  }

  @override
  Future<GetDashboardDataResponseModel> getDashboardData(
      NoParams params) async {
    AuthProvider authProvider = sl();
    String url = AppUrl.baseUrl +
        AppUrl.getDashboardDataUrl +
        '/?userId=${authProvider.currentUser!.id}&isDriver=${authProvider.currentUser!.selectedUserType == '1'}';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);
        return GetDashboardDataResponseModel.fromJson(decryptedJson);
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
  Future<GetVehicleCapacityResponseModel> getVehicleCapacity(
      GetVehicleCapacityRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getVehicleCapacity + params.vehicleId;

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return GetVehicleCapacityResponseModel.fromJson(decryptedJson);
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
  Future<DashboardRideHistoryReponseModel> getDashboardHistoryRides(
      GetDashboardHistoryRidesRequestModel params) async {
    String url = AppUrl.baseUrl +
        AppUrl.dashboardHistoryRides +
        "?userId=${params.userId}&check=${params.check}&isDriver=${params.isDriver}&page=${params.page}";

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decryptedJson = Encryption.decryptJson(response.data);

        return DashboardRideHistoryReponseModel.fromJson(decryptedJson);
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

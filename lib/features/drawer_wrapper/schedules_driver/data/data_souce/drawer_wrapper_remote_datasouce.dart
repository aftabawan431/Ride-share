import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/modals/error_response_model.dart';
import '../../../../../core/modals/no_params.dart';
import '../../../../../core/utils/constants/app_messages.dart';
import '../../../../../core/utils/constants/app_url.dart';
import '../../../../../core/utils/encryption/encryption.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../history/model/get_driver_history_response_model.dart';
import '../../../history/model/get_history_request_model.dart';
import '../../../history/model/get_history_response_model.dart';
import '../../../notification/data/models/get_notifications_response_model.dart';
import '../models/get_driver_schedules_response_model.dart';
import '../models/get_drivers_list_request_model.dart';
import '../models/get_drivers_list_response_model.dart';
import '../models/get_passenger_schdules_response_model.dart';
import '../models/get_requested_passenger_request_model.dart';
import '../models/get_requested_passenger_response_model.dart';
import '../models/get_schedules_requests_model.dart';
import '../models/reschdule_passenger_schedule_request_model.dart';
import '../models/reshedule_driver_route_request_model.dart';
import '../models/reshedule_response_model.dart';


abstract class DrawerWrapperRemoteDatasource {
  /// This method gets the rate list for the countries
  /// [Input]: [NoParams] contains no params
  /// [Output] : if operation successful returns [GetRateListResponseModel] returns the rate list
  /// if unsuccessful the response will be [Failure]
  Future<GetDriverSchedulesResponseModel> getDriverSchedules(GetSchedulesRequestModel params);
  Future<GetPassengerSchdulesResponseModel> getPassengerSchedules(GetSchedulesRequestModel params);
  Future<GetDriversListResponseModel> getDriversList(GetDriversListRequestModel params);
  Future<GetRequestedPassengerResponseModel> getRequestedPassengers(GetRequestedPassengersRequestModel params);
  Future<GetHistoryResponseModel> getHistory(GetHistoryRequestModel params);
  Future<GetDriverHistoryResponseModel> getDriverHistory(GetHistoryRequestModel params);
  Future<GetNotificationsResponseModel> getNotifications(NoParams params);
  Future<RescheduleResponseModel> rescheduleDriverRoute(RescheduleDriverRouteRequestModel params);
  Future<RescheduleResponseModel> reschedulePassengerSchedule(ReschedulePassengerScheduleRequestModel params);

//
// /// This method generates new otp for the specified email
// /// [Input]: [GetAllCardsRequestModel] contains the user id
// /// [Output] : if operation successful returns [GetAllCardsResponseModel] returns the cards list against user id
// /// if unsuccessful the response will be [Failure]
// Future<GetAllCardsResponseModel> getAllCards(GetAllCardsRequestModel params);

}

class DrawerWrapperRemoteDatasourceImp implements DrawerWrapperRemoteDatasource {
  Dio dio;
  DrawerWrapperRemoteDatasourceImp({required this.dio});


  @override
  Future<GetDriverSchedulesResponseModel> getDriverSchedules(GetSchedulesRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getDriverSchedules+'?page=${params.page}';



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);

        return GetDriverSchedulesResponseModel.fromJson(decryptedJson);
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
  Future<GetPassengerSchdulesResponseModel> getPassengerSchedules(GetSchedulesRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getPassengerSchedules+'?page=${params.page}';



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);

        return GetPassengerSchdulesResponseModel.fromJson(decryptedJson);
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
  Future<GetDriversListResponseModel> getDriversList(GetDriversListRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getDriversList;



    try {
      Logger().v(params.toJson());
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);
        Logger().v(decryptedJson);
        return GetDriversListResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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
  Future<GetRequestedPassengerResponseModel> getRequestedPassengers(GetRequestedPassengersRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getRequestedPassengers;



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);
        Logger().v(decryptedJson);

        return GetRequestedPassengerResponseModel.fromJson(decryptedJson);
      }

      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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
  Future<GetHistoryResponseModel> getHistory(GetHistoryRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getHistoryUrl+'?page=${params.page}';
    Logger().v(url);



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));
      final response = await dio.post(url,data: encryptedParams);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);


        return GetHistoryResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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


  Future<GetDriverHistoryResponseModel> getDriverHistory(GetHistoryRequestModel params) async {
    String url = AppUrl.baseUrl + AppUrl.getHistoryUrl+'?page=${params.page}';



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));
      final response = await dio.post(url,data: encryptedParams);
      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);

        Logger().v(decryptedJson);
        return GetDriverHistoryResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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
  Future<GetNotificationsResponseModel> getNotifications(NoParams params) async {
    AuthProvider authProvider=sl();
      String topic=authProvider.currentUser!.selectedUserType=='1'?'drivers':'passengers';

    String url = AppUrl.baseUrl + AppUrl.getNotificationsUrl+'/topic/?topic=$topic';



    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final decryptedJson=Encryption.decryptJson(response.data);

        return GetNotificationsResponseModel.fromJson(decryptedJson);
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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
  Future<RescheduleResponseModel> rescheduleDriverRoute(RescheduleDriverRouteRequestModel params) async {
  // Logger().v("This is call");

    String url = AppUrl.baseUrl + AppUrl.rescheduleDriverRouteUrl;

  // Logger().v(url);


    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);
      // Logger().v(response.data);

      if (response.statusCode == 200) {
        return RescheduleResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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
  Future<RescheduleResponseModel> reschedulePassengerSchedule(ReschedulePassengerScheduleRequestModel params) async {


    String url = AppUrl.baseUrl + AppUrl.reschedulePassengerScheduleUrl;



    try {
      final encryptedParams=Encryption.encryptObject(jsonEncode(params.toJson()));

      final response = await dio.post(url,data: encryptedParams);
      Logger().v(response.data);

      if (response.statusCode == 200) {
        return RescheduleResponseModel();
      }
      throw const SomethingWentWrong(AppMessages.somethingWentWrong);
    } on DioError catch (exception) {
      Logger().v(exception.response);

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

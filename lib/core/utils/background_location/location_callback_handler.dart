import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:logger/logger.dart';

import 'location_service_repository.dart';
class LocationCallbackHandler {
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {

    Logger().v("This is init callback");
    Logger().v(params);
    LocationServiceRepository.routeId=params['routeId'];

    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();

    await myLocationCallbackRepository.init(params);
  }
  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {

    Logger().v("This is dispose handler");
    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }
  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {

    LocationServiceRepository myLocationCallbackRepository =
    LocationServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
  }

  static Future<void> notificationCallback() async {
  }
}

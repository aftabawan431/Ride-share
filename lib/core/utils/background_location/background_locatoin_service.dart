import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'location_callback_handler.dart';
import 'location_service_repository.dart';

class BackgroundLocationService {
  static Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
    await BackgroundLocator.isServiceRunning();

  }

  static Future<void> stop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    await BackgroundLocator.isServiceRunning();
  }

  static Future<void> start(String routeId) async {
    await _startLocator(routeId);
     await BackgroundLocator.isServiceRunning();
  }

  static Future<void> _startLocator(String routeId) async {
    Logger().v("Starting the locator");

    Map<String, dynamic> data = {'routeId': routeId};
    LocationServiceRepository.routeId=data['routeId'];

    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: const IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: 0,
            stopWithTerminate: true),
        autoStop: false,
        androidSettings: const AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Rahper',
                notificationMsg: 'Tracking location in background',
                notificationBigMsg:
                    'Your location will be live once you start a drive.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }
}

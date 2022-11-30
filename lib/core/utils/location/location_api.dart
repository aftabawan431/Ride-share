import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../features/ride/presentation/providers/driver_ride_provider.dart';
import '../constants/socket_point.dart';
import '../encryption/encryption.dart';
import '../globals/globals.dart';
import '../globals/snake_bar.dart';
import '../sockets/sockets.dart';

class LocationApi {
  static String locationRoomId = '';
  static StreamSubscription<Position>? positionStream;

  /// to get current location of the user
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, please allow permissions from setting');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    return position;
  }

  /// To check if location permissino or location is enabled on device
  static Future<bool> checkPermissions() async {


    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    } else {
      return false;
    }
  }

  ///To check if location permissino or location is enabled on device, it will also display error if there is any
  static Future<bool> canLocate() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ShowSnackBar.show('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ShowSnackBar.show('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ShowSnackBar.show(
          'Location permissions are permanently denied, please allow permissions from setting');
      return false;
    }

    return true;
  }

  static startBackgroundLocationListener() {
    if (positionStream == null) {
      _backgroundLocationStream();
    }
  }

  static stopBackgroundLocationListener() {
    if (positionStream != null) {
      positionStream!.cancel();
      positionStream == null;
    }
  }

  static _backgroundLocationStream() {
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 5),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationText: "Your location is live",
              notificationTitle: "Running in Background",
              enableWakeLock: true,
              enableWifiLock: true));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      );
    }

    Logger().v("Starting listening for updates");

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      Logger().v(position!.toJson());
      AuthProvider authProvider = sl();
      final data = {
        "routeId": locationRoomId,
        "location": {
          "latitude": position.latitude,
          "longitude": position.longitude
        }
      };
      final encryptedParams = Encryption.encryptObject(jsonEncode(data));

      SocketService.socket!
          .emit(SocketPoint.updateDriverLocatin, jsonEncode(encryptedParams));
      DriverRideProvider driverRideProvider = sl();

      driverRideProvider.updateDriverLocation(position);

      // await Dio().get("http://192.168.4.156:3002/api/test");


    });
  }
}

import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'core/utils/firebase/push_notification_service.dart';
import 'core/utils/globals/globals.dart';
import 'dependency_container.dart' as di;
import 'myApp.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await PushNotifcationService().initialize();
//   await di.init();
//   Dio dio = sl();
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
//
//
//   // dio.interceptors.add(DioLogInterceptor());
//
//   runApp(
//       // MyApp()
//       DevicePreview(
//     enabled: false,
//     builder: (context) => const MyApp(), // Wrap your app
//   ));
// }

void main() async {

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await PushNotifcationService().initialize();
    await di.init();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;





    runApp(const MyApp());
  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}




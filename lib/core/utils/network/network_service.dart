import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class NetworkService {
  static late StreamSubscription<ConnectivityResult> stream;

 static listen() {
    stream = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      Logger().v(result);
      // Got a new connectivity status!
    });
  }

 static dispose() {
    stream.cancel();
  }
}

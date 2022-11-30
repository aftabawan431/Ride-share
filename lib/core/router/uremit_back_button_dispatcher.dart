import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/globals/loading.dart';
import 'package:logger/logger.dart';

import 'app_state.dart';

class UremitBackButtonDispatcher extends RootBackButtonDispatcher {
  final AppState appState;

  UremitBackButtonDispatcher(this.appState) : super();

  @override
  Future<bool> didPopRoute() async {

    Logger().v("1");

    appState.moveToBackScreen();
    return true;
  }
}

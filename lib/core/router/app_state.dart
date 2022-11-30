import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/globals/globals.dart';
import 'pages.dart';
import 'package:get_it/get_it.dart';

import '../utils/enums/app_state_enum.dart';
import '../utils/enums/page_state_enum.dart';
import 'models/page_action.dart';
import 'models/page_config.dart';

/// This class contains the global state of the app
class AppState extends ChangeNotifier {
  AppStateEnum appStateEnum = AppStateEnum.none;

  PageAction _currentAction = const PageAction();
  PageAction get currentAction => _currentAction;
  Completer<dynamic>? waitToPop;

  ValueChanged<String>? globalErrorShow;

  /// This method resets your page action
  void resetCurrentAction() {
    _currentAction = PageAction(
        state: PageState.replaceAll, page: PageConfigs.splashPageConfig);
  }

  /// this method is used to change the page of the app
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  addWidget({required PageConfiguration page,required Widget child}){
    AppState appState=sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: page,
        widget: child);
  }
  Future goToNext(PageConfiguration pageConfigs,
      {PageState pageState = PageState.addPage, bool wait = false}) async {
    AppState appState = GetIt.I.get<AppState>();
    if (wait) {
      willWait();
    }
    appState.currentAction = PageAction(
      state: pageState,
      page: pageConfigs,
    );
    if (wait) {
      await startWaiting();
    }
  }

  removePage(PageConfiguration pageConfigs) {
    currentAction = PageAction(page: pageConfigs, state: PageState.remove);
  }

  void moveToBackScreen() {

    currentAction = const PageAction(state: PageState.pop);
    if (waitToPop != null) {
      waitToPop!.complete(true);
      waitToPop = null;
    }
  }

  willWait() {
    waitToPop = Completer();
  }

  Future startWaiting() async {
    return waitToPop!.future;
  }

  stopWaiting(dynamic value) {
    waitToPop!.complete(value);
    waitToPop = null;
  }
}

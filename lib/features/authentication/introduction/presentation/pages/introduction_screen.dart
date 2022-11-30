import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_slider/introduction_slider.dart';

import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/location/location_api.dart';
import '../../../auth_wrapper/presentation/providers/auth_provider.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IntroductionScreenContent();
  }
}

class IntroductionScreenContent extends StatelessWidget {
  const IntroductionScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IntroductionSlider(
          selectedDotColor: Theme.of(context).primaryColor,
          onDone: Container(),
          skip: TextButton(
            onPressed: () async {
              if (await LocationApi.checkPermissions() || Platform.isIOS) {
                AppState appState = GetIt.I.get<AppState>();
                appState.currentAction = PageAction(
                    state: PageState.replace,
                    page: PageConfigs.dashboardPageConfig);
                AuthProvider authProvider = sl();
                authProvider.updateUserOnDisk();
              } else {
                AppState appState = GetIt.I.get<AppState>();
                appState.currentAction = PageAction(
                    state: PageState.replaceAll,
                    page: PageConfigs.locationPermissionPageConfig);
              }
            },
            child: Text("SKIP"),
          ),
          done: TextButton(
              onPressed: () async {
                if (await LocationApi.checkPermissions() || Platform.isIOS) {
                  AppState appState = GetIt.I.get<AppState>();
                  appState.currentAction = PageAction(
                      state: PageState.replace,
                      page: PageConfigs.dashboardPageConfig);
                  AuthProvider authProvider = sl();
                  authProvider.updateUserOnDisk();
                } else {
                  AppState appState = GetIt.I.get<AppState>();
                  appState.currentAction = PageAction(
                      state: PageState.replaceAll,
                      page: PageConfigs.locationPermissionPageConfig);
                }
              },
              child: const Text("Done")),
          items: [
            IntroductionSliderItem(
              image: SvgPicture.asset(AppAssets.walkthrought1Svg),
              title: "Request Ride",
              description:
                  "Request a ride get picked up by a nearby community driver",
            ),
            IntroductionSliderItem(
              image: SvgPicture.asset(AppAssets.walkthrought2Svg),
              title: "Confirm Your Driver",
              description:
                  "Huge drivers network helps you find comfortable, safe and cheap ride",
            ),
            IntroductionSliderItem(
              image: SvgPicture.asset(AppAssets.walkthrought3Svg),
              title: "Track Your Ride",
              description:
                  "Know your driver in advance and be able to view current location in real time on the map",
            ),
          ],
        ),
      ),
    );
  }
}

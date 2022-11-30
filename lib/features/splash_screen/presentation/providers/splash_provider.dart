import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/globals/snake_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/modals/no_params.dart';
import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/router/pages.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/location/location_api.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../../authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import '../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../domain/use_cases/get_user_usecase.dart';

class SplashProvider extends ChangeNotifier {
  final GetUserUsecase _getUserUsecase;
  SplashProvider(this._getUserUsecase);
  bool moveToLogin = false;

  getCurrentUser() async {
    var loginEither = await _getUserUsecase.call(NoParams());
    OtpProvider otp = sl();
    otp.canResend = true;

    if (loginEither.isLeft()) {
      Timer(const Duration(milliseconds: 1000), () {
        goToPage(PageConfigs.selectUserPageConfig,
            pageState: PageState.replace);
      });
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        await Future.delayed(const Duration(milliseconds: 400));
        AuthProvider _authProvider = sl();
        _authProvider.currentUser = response;
        if (response.selectedUserType == '1') {
          if (response.emailVerified && response.mobileVerified) {

            await getUserProfile();


            if (response.documentUpload == false ||
                response.documentVerified.status == 'pending' ||
                response.documentVerified.status == 'rejected') {
              await const FlutterSecureStorage().delete(key: 'user');
              moveToLogin = true;
              onBackPress = () {
                DashboardProvider dashboardProvider = sl();
                dashboardProvider.switchRole();
              };

              goToPage(PageConfigs.driverDocumentVerification);
              return;
            }
            if (await LocationApi.checkPermissions()||Platform.isIOS) {
              goToPage(PageConfigs.dashboardPageConfig);
            } else {
              goToPage(PageConfigs.locationPermissionPageConfig);
            }
          } else {
            await const FlutterSecureStorage().delete(key: 'user');
            otp.byDefaultSmsOtp = response.mobileVerified;
            otp.byDefaultEmailOtp = response.emailVerified;
            otp.emailVerified = response.emailVerified;
            otp.phoneVerified = response.mobileVerified;
            goToPage(PageConfigs.driverOtpPageConfig);
            onBackPress = () {
              DashboardProvider dashboardProvider = sl();
              dashboardProvider.switchRole();
            };
          }
        } else {
          if (response.mobileVerified) {
            await getUserProfile();
            if (await LocationApi.checkPermissions()||Platform.isIOS) {
              goToPage(PageConfigs.dashboardPageConfig);
            } else {
              goToPage(PageConfigs.locationPermissionPageConfig);
            }
          } else {
            goToPage(PageConfigs.userOtpPageConfig);
          }
        }
      });
    }
  }

  Future getUserProfile() async {
    AuthProvider authProvider = sl();
    await authProvider.getUserProfile();
  }

  goToPage(PageConfiguration configuration,
      {PageState pageState = PageState.replace}) {
    AppState appState = GetIt.I.get<AppState>();
    appState.currentAction = PageAction(state: pageState, page: configuration);
  }
}

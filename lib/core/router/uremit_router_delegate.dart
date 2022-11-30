import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/router/models/page_paths.dart';
import 'package:flutter_rideshare/core/utils/globals/loading.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/pages/display_receipt_screen.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/history/presentation/pages/driver_history_screen.dart';
import 'package:flutter_rideshare/features/wallet/presentation/pages/create_zindigi_account_screen.dart';
import 'package:flutter_rideshare/features/wallet/presentation/pages/link_account_screen.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/pages/payfast_pay_screen.dart';
import 'package:flutter_rideshare/features/dashboard/presentation/pages/select_gateway_screen.dart';
import 'package:flutter_rideshare/features/wallet/presentation/pages/user_wallet_screen.dart';
import 'package:logger/logger.dart';
import '../utils/extension/extensions.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/find_account_screen.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/location_permission_screen.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/otp_verification_driver.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/otp_verification_user.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/reset_password_screen.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/sign_in_screen.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/signup_screen.dart';
import '../../features/authentication/document_verification/presenetation/pages/driver_document_upload_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/drawer_wrapper/schedules_driver/presentation/pages/choose_location_from_map_screen.dart';
import '../../features/ride/presentation/pages/driver_ride_screen.dart';
import '../../features/ride/presentation/pages/passenger_ride_screen.dart';
import '../../features/vehicles/presentation/pages/vechicle_management.dart';
import '../../features/vehicles/presentation/pages/vehicle_details_screen.dart';
import '../../features/authentication/introduction/presentation/pages/introduction_screen.dart';
import '../../features/authentication/select_user/presentation/pages/select_user_screen.dart';
import '../../features/dashboard/presentation/pages/new_ride_screen.dart';
import '../../features/dashboard/presentation/pages/passengers_screen.dart';
import '../../features/dashboard/presentation/pages/rating_screen.dart';
import '../../features/drawer_wrapper/history/presentation/pages/history_screen.dart';
import '../../features/drawer_wrapper/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/drawer_wrapper/notification/presentation/pages/invite_code_screen.dart';
import '../../features/drawer_wrapper/notification/presentation/pages/notification_screen.dart';
import '../../features/drawer_wrapper/profile/presentation/pages/profile_screen.dart';
import '../../features/drawer_wrapper/schedules_driver/presentation/pages/driver_schedules_screen.dart';
import 'package:move_to_background/move_to_background.dart';

import '../../features/authentication/auth_wrapper/presentation/pages/delete_account_password_confirmation_screen.dart';
import '../../features/authentication/auth_wrapper/presentation/pages/reset_password_otp_screen.dart';
import '../../features/drawer_wrapper/schedules_driver/presentation/pages/passenger_scdules_screen.dart';
import '../../features/splash_screen/presentation/pages/splash_screen.dart';
import '../utils/enums/page_state_enum.dart';
import '../utils/globals/globals.dart';
import 'app_state.dart';
import 'pages.dart';

BuildContext?
    globalHomeContext; // doing this to pop the bottom sheet on dashboard screen

class UremitRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  late final AppState appState;
  final List<Page> _pages = [];
  late BackButtonDispatcher backButtonDispatcher;

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  UremitRouterDelegate(this.appState) {
    appState.addListener(() {
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Faulty Code will need to find a way to solve it
    appState.globalErrorShow = (value) {
      context.show(message: value);
    };

    return Container(
      key: ValueKey(pages.last.name),
      child: Navigator(
        key: navigatorKeyGlobal,
        onPopPage: _onPopPage,
        pages: buildPages(),
      ),
    );
  }

  List<Page> buildPages() {
    switch (appState.currentAction.state) {
      case PageState.none:
        break;
      case PageState.addPage:
        addPage(appState.currentAction.page!);
        break;
      case PageState.remove:
        removePage(appState.currentAction.page!);
        break;

      case PageState.pop:
        pop();
        break;
      case PageState.addAll:
        // TODO: Handle this case.
        break;
      case PageState.addWidget:
        final shouldAddPage =
            _pages.isEmpty || (_pages.last.name !=  appState.currentAction.page!.path);
        if(shouldAddPage){
          pushWidget(
              appState.currentAction.widget!, appState.currentAction.page!);
        }

        break;
      case PageState.replace:
        replace(appState.currentAction.page!);
        break;
      case PageState.replaceAll:
        replaceAll(appState.currentAction.page!);
        break;
    }
    return List.of(_pages);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void replaceAll(PageConfiguration newRoute) {
    _pages.clear();
    setNewRoutePath(newRoute);
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void removePage(PageConfiguration page) {
    if (_pages.isNotEmpty) {
      int index = _pages.indexWhere((element) => element.name == page.path);
      if (index != -1) {
        _pages.removeAt(index);
      }
    }
  }

  /// This method adds pages based on the PageConfig received
  /// [Input]: [PageConfiguration]
  void addPage(PageConfiguration pageConfig) {
    final shouldAddPage =
        _pages.isEmpty || (_pages.last.name != pageConfig.path);

    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.splashPage:
          _addPageData(SplashScreen(), pageConfig);
          // _addPageData(const DashboardPage(), pageConfig);
          break;
        case Pages.selectUserPage:
          _addPageData(const SelectUserScreen(), pageConfig);
          break;
        case Pages.signinPage:
          _addPageData(SigninScreen(), pageConfig);
          break;
        case Pages.signupPage:
          _addPageData(SignupScreen(), pageConfig);
          break;
        case Pages.introductionPage:
          _addPageData(const IntroductionScreen(), pageConfig);
          break;

        case Pages.userOtpPage:
          _addPageData(UserOtpVerification(), pageConfig);
          break;
        case Pages.driverOtpPage:
          _addPageData(DriverOtpVerification(), pageConfig);
          break;
        case Pages.vehicleDetailsPage:
          _addPageData(VehicleDetailsScreen(), pageConfig);
          break;
        case Pages.passengerPage:
          _addPageData(const PassengerScreen(), pageConfig);
          break;
        case Pages.ratingPage:
          _addPageData(RatingScreen(), pageConfig);
          break;
        case Pages.historyPage:
          _addPageData(HistoryScreen(), pageConfig);
          break;
        case Pages.notificationPage:
          _addPageData(NotificationScreen(), pageConfig);
          break;
        case Pages.inviteFriendsPage:
          _addPageData(const InviteCodeScreen(), pageConfig);
          break;

        case Pages.profileScreenPage:
          _addPageData(ProfileScreen(), pageConfig);
          break;

        case Pages.editProfilePage:
          _addPageData(EditProfileScreen(), pageConfig);
          break;

        case Pages.driverSchedulesPage:
          _addPageData(DriverSchedulesScreen(), pageConfig);
          break;
        case Pages.passengerSchedulesPage:
          _addPageData(PassengerSchedulesScreen(), pageConfig);
          break;
        case Pages.newRidePage:
          _addPageData(NewRideScreen(), pageConfig);
          break;
        case Pages.vehicleManagement:
          _addPageData(VehicleManagementScreen(), pageConfig);
          break;
        case Pages.driverRidePage:
          _addPageData(DriverRideScreen(), pageConfig);
          break;
        case Pages.passengerRidePage:
          _addPageData(PassengerRideScreen(), pageConfig);
          break;
        case Pages.findAccountPage:
          _addPageData(FindAccountScreen(), pageConfig);
          break;
        case Pages.resetPasswordOtpPage:
          _addPageData(ResetPasswordOtpScreen(), pageConfig);
          break;
        case Pages.resetPasswordPage:
          _addPageData(ResetPasswordScreen(), pageConfig);
          break;

        case Pages.dashboardPage:
          _addPageData(DashboardScreen(), pageConfig);
          break;
        case Pages.chooseLocationFromMapPage:
          _addPageData(ChooseLocationFromMapScreen(), pageConfig);
          break;

        case Pages.driverDocumentVerificationPage:
          _addPageData(DriverDocuementUploadScreen(), pageConfig);
          break;

        case Pages.locationPermissionPage:
          _addPageData(const LocationPermissionScreen(), pageConfig);
          break;
        case Pages.deleteAccountConfirmationPassword:
          _addPageData(DeleteAccountPasswordConfirmationScreen(), pageConfig);
          break;
        case Pages.userWalletPage:
          _addPageData(UserWalletScreen(), pageConfig);
          break;
        case Pages.linkZindigiAccountPage:
          _addPageData(LinkZindigiAccountScreen(), pageConfig);
          break;
        case Pages.displayReceiptPage:
          _addPageData(const DisplayReceiptScreen(), pageConfig);
          break;
        case Pages.paymentGatewayPage:
          _addPageData(const PaymentGatewayScreen(), pageConfig);
          break;

        case Pages.createZindigiAccountPage:
          _addPageData(CreateZindigiAccountScreen(), pageConfig);
          break;

          case Pages.driverHistoryPage:
          _addPageData(DriverHistoryScreen(), pageConfig);
          break;
      }
    }
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {

    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    Logger().v("2");

    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void pop() {
    Logger().v("3");
    if (globalHomeContext != null) {
      Navigator.of(globalHomeContext!).pop();
      globalHomeContext = null;
      return;
    }
    if (onBackPress != null) {
      onBackPress!();
      onBackPress = null;
      return;
    }
    if (canPop()) {
      AppState appState = sl();
      if (appState.waitToPop != null) {
        appState.stopWaiting(null);
      }


      if (isMapPage()) {
        sleep(const Duration(milliseconds: 2500));
      };

      _removePage(_pages.last as MaterialPage);

    } else {
      // if (_pages.last.name != PagePaths.authWrapperPagePath) {
      //   _homeViewModel.onBottomNavTap(0);
      // }
    }
  }

  bool isMapPage() {
    final page = _pages.last;
    return (page.name == PagePaths.driverRideScreenPagePath ||
        page.name == PagePaths.passengerRideScreenPagePath ||
        page.name == PagePaths.newRidePagePath
        ||
        page.name == PagePaths.chooseLocationFromMapPagePath
    );
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
    // notifyListeners();
  }

  bool canPop() {
    if (_pages.length > 1) {
      return true;
    }

    DashboardProvider dashboardProvider=sl();
    dashboardProvider.setDashboardDropOfLocation(null);
    dashboardProvider.setIsScheduled(false);

    // MoveToBackground.moveTaskToBack();
    return false;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage =
        _pages.isEmpty || (_pages.last.name != configuration.path);

    if (!shouldAddPage) {
      return SynchronousFuture(null);
    }
    _pages.clear();
    addPage(configuration);

    return SynchronousFuture(null);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => navigatorKeyGlobal;
}

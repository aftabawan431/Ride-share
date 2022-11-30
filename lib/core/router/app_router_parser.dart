import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/page_config.dart';
import 'models/page_paths.dart';
import 'pages.dart';

class RouterParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '');

    if (uri.pathSegments.isEmpty) {
      return SynchronousFuture(PageConfigs.splashPageConfig);
    }

    final path = '/' + uri.pathSegments[0];

    switch (path) {
      case PagePaths.splashPagePath:
        return SynchronousFuture(PageConfigs.splashPageConfig);
      default:
        return SynchronousFuture(PageConfigs.splashPageConfig);
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.splashPage:
        return const RouteInformation(location: PagePaths.splashPagePath);
      case Pages.selectUserPage:
        return const RouteInformation(location: PagePaths.selectUserPagePath);
      case Pages.signupPage:
        return const RouteInformation(location: PagePaths.selectUserPagePath);
      case Pages.signinPage:
        return const RouteInformation(location: PagePaths.selectUserPagePath);
      case Pages.introductionPage:
        return const RouteInformation(location: PagePaths.selectUserPagePath);
      case Pages.driverOtpPage:
        return const RouteInformation(location: PagePaths.driverOtpPagePath);
      case Pages.userOtpPage:
        return const RouteInformation(location: PagePaths.userOtpPagePath);
      case Pages.vehicleDetailsPage:
        return const RouteInformation(location: PagePaths.vehiclePagePath);
      case Pages.passengerPage:
        return const RouteInformation(location: PagePaths.passengerPagePath);
      case Pages.ratingPage:
        return const RouteInformation(location: PagePaths.ratingPagePath);
      case Pages.historyPage:
        return const RouteInformation(location: PagePaths.historyPagePath);
      case Pages.notificationPage:
        return const RouteInformation(location: PagePaths.notificationPagePath);
      case Pages.inviteFriendsPage:
        return const RouteInformation(
            location: PagePaths.inviteFriendsPagePath);
      case Pages.profileScreenPage:
        return const RouteInformation(
            location: PagePaths.profileScreenPagePath);
      case Pages.editProfilePage:
        return const RouteInformation(location: PagePaths.editProfilePagePath);
      case Pages.driverSchedulesPage:
        return const RouteInformation(
            location: PagePaths.driverSchedulesScreenPagePath);
      case Pages.newRidePage:
        return const RouteInformation(location: PagePaths.newRidePagePath);
      case Pages.vehicleManagement:
        return const RouteInformation(
            location: PagePaths.vehicleManagementScreenPagePath);
      case Pages.passengerSchedulesPage:
        return const RouteInformation(
            location: PagePaths.passengerSchedulesScreenPagePath);
      case Pages.driversListPage:
        return const RouteInformation(location: PagePaths.driversListPagePath);
      case Pages.requestedPassengersPage:
        return const RouteInformation(
            location: PagePaths.requestedPassengersPagePath);
      case Pages.passengerRidePage:
        return const RouteInformation(
            location: PagePaths.passengerRideScreenPagePath);
      case Pages.driverRidePage:
        return const RouteInformation(
            location: PagePaths.driverRideScreenPagePath);
      case Pages.findAccountPage:
        return const RouteInformation(
            location: PagePaths.findAccountScreenPagePath);
      case Pages.resetPasswordOtpPage:
        return const RouteInformation(
            location: PagePaths.resetPasswordOtpScreenPagePath);
      case Pages.resetPasswordPage:
        return const RouteInformation(
            location: PagePaths.resetPasswordScreenPagePath);
      case Pages.dashboardPage:
        return const RouteInformation(location: PagePaths.dashboardPagePath);
      case Pages.chooseLocationFromMapPage:
        return const RouteInformation(
            location: PagePaths.chooseLocationFromMapPagePath);

      case Pages.chatPage:
        return const RouteInformation(location: PagePaths.chatScreenPagePath);
      case Pages.dashboardRideHistoryPage:
        return const RouteInformation(
            location: PagePaths.dashboardRideHistoryPagePath);

        case Pages.driverDocumentVerificationPage:
        return const RouteInformation(
            location: PagePaths.driverDocumentVerificationPagePath);

        case Pages.locationPermissionPage:
        return const RouteInformation(
            location: PagePaths.locationPermissionPagePath);

        case Pages.deleteAccountConfirmationPassword:
        return const RouteInformation(
            location: PagePaths.deleteAccountConfirmationPasswordPagePath);

        case Pages.userWalletPage:
        return const RouteInformation(
            location: PagePaths.userWalletPagePath);
        case Pages.payFastPaymentPage:
        return const RouteInformation(
            location: PagePaths.payfastPaymentPagePath);
        case Pages.linkZindigiAccountPage:
        return const RouteInformation(
            location: PagePaths.linkZindigiPagePath);

        case Pages.displayReceiptPage:
        return const RouteInformation(
            location: PagePaths.displayReceiptPagePath);
        case Pages.paymentGatewayPage:
        return const RouteInformation(
            location: PagePaths.paymentGatewayPagePath);

        case Pages.createZindigiAccountPage:
        return const RouteInformation(
            location: PagePaths.createZindigiAccountPagePath);
        case Pages.driverHistoryPage:
        return const RouteInformation(
            location: PagePaths.driverHistoryPagePath);
    }
  }
}

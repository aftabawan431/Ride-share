import 'package:equatable/equatable.dart';

class PageConfiguration extends Equatable {
  final String key;
  final String path;
  final Pages uiPage;
  final Map<String, dynamic> arguments;

  const PageConfiguration({
    required this.key,
    required this.path,
    required this.uiPage,
    this.arguments = const {},
  });
  factory PageConfiguration.withArguments(PageConfiguration pageConfiguration, Map<String, dynamic> arguments) {
    return PageConfiguration(uiPage: pageConfiguration.uiPage, key: pageConfiguration.key, path: pageConfiguration.path, arguments: arguments);
  }
  @override
  List<Object?> get props => [key, path, uiPage, arguments];
}

enum Pages {
  splashPage,
  selectUserPage,
  signupPage,
  signinPage,
  introductionPage,
  vehicleDetailsPage,
  userOtpPage,
  driverOtpPage,
  passengerPage,
  ratingPage,
  historyPage,
  notificationPage,
  inviteFriendsPage,
  profileScreenPage,
  editProfilePage,
  driverSchedulesPage,
  passengerSchedulesPage,
  newRidePage,
  dashboardPage,
  vehicleManagement,
  driversListPage,
  requestedPassengersPage,
  passengerRidePage,
  driverRidePage,
  findAccountPage,
  resetPasswordOtpPage,
  resetPasswordPage,
  chooseLocationFromMapPage,
  chatPage,
  dashboardRideHistoryPage,
  driverDocumentVerificationPage,
  locationPermissionPage,
  deleteAccountConfirmationPassword,
  userWalletPage,
  payFastPaymentPage,
  linkZindigiAccountPage,
  displayReceiptPage,
  paymentGatewayPage,
  createZindigiAccountPage,
  driverHistoryPage,
}

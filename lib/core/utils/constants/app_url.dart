import '../../../features/authentication/document_verification/presenetation/pages/driver_document_upload_screen.dart';
import '../../../features/drawer_wrapper/profile/presentation/pages/edit_profile_screen.dart';

class AppUrl {

  static const bool _isProduction = false;
  static  String baseUrl = _isProduction
      ? 'http://'
      : 'http://';
  static  String fileBaseUrl = _isProduction
      ? 'http://'
      : 'http://';
  static const String loginUrl = 'api/user/login';
  static const String registerUrl = 'api/user/register';
  static const String valiteEmailOtpUrl = 'api/user/verifyemail';
  static const String validatePhoneUrl = 'api/user/verifymobile';
  static const String getVehicleInitials = 'api/util/registerutil';
  static const String getModelsFromMakerUrl = 'api/vehiclemodel/list';
  static const String getCityFromProviceUrl = 'api/city/listbyprovince';
  static const String addVehicleUrl = 'api/vehicle';
  static const String getVehiclesUrl = 'api/user/getuservehiclelist';
  static const String deleteVehicleUrl = 'api/user/deletevehicle';
  static const String updateSelectedVehicle = 'api/user/updateselectedvehicle';
  static const String resendOtpUrl = 'api/user/sendotp';
  static const String findAccountUrl = 'api/user/otprequest';
  static const String resetPasswordUrl = 'api/user/resetpassword';
  static const String logoutUserUrl = 'api/user/logout';
  static const String driverDocumentUploadUrl = 'api/user/uploadDocument';
  static const String addDriverRideRequestUrl = 'api/route/';
  static const String addPassengerRideRequestUrl = 'api/scheduleride';
  static const String addRating = 'api/rating';
  static const String switchRoleUrl = 'api/user/switch';
  static const String getDashboardDataUrl = 'api/dashboard';
  static const String getVehicleCapacity = 'api/vehicle/seats?vehicleId=';
  static const String getDriverSchedules = 'api/route/driverroutes';
  static const String getPassengerSchedules =
      'api/scheduleride/getuserschedules';
  static const String getDriversList = 'api/scheduleride/getmatcheddriver';
  static const String getRequestedPassengers = 'api/route/getrequests';
  static const String getHistoryUrl = 'api/history/getuserhistory';
  static const String getNotificationsUrl = 'api/systemNotification';
  static const String rescheduleDriverRouteUrl = 'api/route/reSchedule';
  static const String reschedulePassengerScheduleUrl =
      'api/scheduleride/reschedule';
  static const String dashboardHistoryRides = 'api/user/schedules';
  static const String updateProfileImageUrl = 'api/user/profileimage';

  /// UI is in [EditProfileScreen]
  static const String updateProfileUrl = 'api/user/updateprofile';

  ///UI is in [DriverDocuementUploadScreen], driver is obliged to upload verify his/her document, so documents will be uploaded by this API
  static const String documentUploadUrl = 'api/user/uploadDocument';
  static const String deleteAccountUrl = 'api/user';
  static const String newNumberAvailbleCheckUrl = 'api/user/lookup';
  static const String updateMobileNumberUrl = 'api/user/updateMoible';
  static const String getSimProvidersUrl = 'api/simProviders/list';
  static const String getUserProfileUrl = 'api/user/getprofile';

  static const String getWalletInfoUrl = 'api/user/getWalletInfo';
  static const String validateZindigiAccountUrl =
      'api/zindigi/verifyAccountToLink';
  static const String linkZindigiAccountUrl = 'api/zindigi/linkAccount';
  static const String createZindigiAccountUrl = 'api/zindigi/accountOpening';

  static const String unlinkZindigiAccount = 'api/user/unlinkZindigiAccount';
  static const String zindigiWalletOtp = 'api/user/zindigiwalletOTP';
}

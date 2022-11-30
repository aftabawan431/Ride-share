import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';

import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/core/utils/services/device_info_service.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/change_number_available_check_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_user_profile_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/change_number_availble_check_usecase.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/pages/find_account_screen.dart';
import 'package:logger/logger.dart';
import '../../../../../core/router/pages.dart';
import '../../../../../core/utils/background_location/background_locatoin_service.dart';
import '../../../../../core/utils/constants/app_assets.dart';
import '../../../../../core/utils/enums/user_type.dart';
import '../../../../../core/utils/files/file_utils.dart';
import '../../../../../core/utils/firebase/push_notification_service.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/loading.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/utils/location/location_api.dart';
import '../../../../../core/utils/sockets/sockets.dart';
import '../../../../../core/utils/storage/secure_storage.dart';
import '../../../../../core/widgets/modals/confirmation_dialog.dart';
import '../../../../../core/widgets/modals/display_status_model.dart';
import '../../../../dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../data/models/delete_account_request_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_modal.dart';
import '../../data/models/logout_request_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../data/models/update_selected_vehicle_request_model.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/driver_document_upload_usecase.dart';
import '../../domain/usecases/find_account_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'otp_provider.dart';
import '../../../document_verification/models/driver_document_upload_request_model.dart';
import '../../../../drawer_wrapper/notification/presentation/providres/notification_provider.dart';
import '../../../../drawer_wrapper/profile/data/model/add_profile_image_request_model.dart';
import '../../../../drawer_wrapper/profile/data/model/update_profile_request_model.dart';
import '../../../../drawer_wrapper/profile/domain/usecases/update_profile_image_usecase.dart';
import '../../../../drawer_wrapper/profile/domain/usecases/update_profile_usecase.dart';
import '../../../../drawer_wrapper/profile/domain/usecases/update_selected_vehicle_usecase.dart';
import '../../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../splash_screen/presentation/providers/splash_provider.dart';
import '../../../../vehicles/presentation/providers/vechicle_provider.dart';
import '../../data/models/find_account_request_model.dart';
import '../../domain/usecases/reset_password_usecase.dart';

class AuthProvider extends ChangeNotifier {
  // notifiers
  ValueNotifier<bool> loginLoading = ValueNotifier(false);
  ValueNotifier<bool> registerLoading = ValueNotifier(false);
  ValueNotifier<bool> findAccountLoading = ValueNotifier(false);
  ValueNotifier<bool> updateProfileImageLoading = ValueNotifier(false);
  ValueNotifier<bool> updateSelectedVehicleLoading = ValueNotifier(false);
  ValueNotifier<bool> updateProfileLoading = ValueNotifier(false);
  ValueNotifier<bool> newNumberAvailbleCheckLoading = ValueNotifier(false);
  ValueNotifier<bool> resetPasswordLoading = ValueNotifier(false);
  ValueNotifier<bool> deleteAccountLoading = ValueNotifier(false);
  ValueNotifier<bool> uploadVerificationDocumentLoading = ValueNotifier(false);

  // usecases

  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final UpdateProfileImageUsecase _updateProfileImageUsecase;
  final UpdateSelectedVehicleUsecase _updateSelectedVehicleUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final GetUserProfileUsecase _getUserProfileUsecase;
  final NewNumberAvailbleCheckUsecase _newNumberAvailbleCheckUsecase;
  final LogoutUsecase _logoutUsecase;
  final FindAccountUsecase _findAccountUsecase;
  final DriverDocumentUploadUsecase _driverDocumentUploadUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  AuthProvider(
    this._loginUsecase,
    this._registerUsecase,
    this._updateProfileImageUsecase,
    this._updateProfileUsecase,
    this._updateSelectedVehicleUsecase,
    this._findAccountUsecase,
    this._resetPasswordUsecase,
    this._logoutUsecase,
    this._driverDocumentUploadUsecase,
    this._deleteAccountUsecase,
    this._newNumberAvailbleCheckUsecase,
    this._getUserProfileUsecase,
  );

  //screen properties

  User? currentUser;

  /// To check whether to show Change Phone Number UI or Find Account UI on [FindAccountScreen]
  bool isFindAccount = false;

  //form properties

  UserType? userType;

  //document verification
  File? frontSideImage;
  File? backSideImage;

  // Login Screen

  TextEditingController findAccountController = TextEditingController();
  final FocusNode loginMobileFocusNode = FocusNode();

  bool fromProfileScreen = false;

  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController loginPhoneController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();

  final FocusNode loginPasswordFocusNode = FocusNode();
  final FocusNode resetPasswordFocusNode = FocusNode();
  final FocusNode resetConfirmPasswordFocusNode = FocusNode();

  // Register Screen

  final TextEditingController registerFirstNameController =
      TextEditingController();

  final TextEditingController registerPhoneController = TextEditingController();
  final FocusNode registerFirstNameFocusNode = FocusNode();
  final FocusNode updateFirstNameFocusNode = FocusNode();

  final TextEditingController registerLastNameController =
      TextEditingController();
  final TextEditingController profileMobileNumber = TextEditingController();
  final FocusNode registerLastNameFocusNode = FocusNode();
  final FocusNode updateLastNameFocusNode = FocusNode();
  final FocusNode registerPhoneFocusNode = FocusNode();

  final TextEditingController dobController = TextEditingController();
  final FocusNode dobFocusNode = FocusNode();

  final TextEditingController updateCorporateCodeController =
      TextEditingController();
  final FocusNode updateCorporateCodeFocusNode = FocusNode();

  final FocusNode udpateDOBFocusNode = FocusNode();

  final TextEditingController registerEmailController = TextEditingController();
  final FocusNode registerEmailFocusNode = FocusNode();

  final TextEditingController registerCnicController = TextEditingController();
  final FocusNode registerCnicFocusNode = FocusNode();

  final TextEditingController registerPasswordController =
      TextEditingController();

  final TextEditingController registerConfirmPasswordController =
      TextEditingController();
  final FocusNode registerPasswordFocusNode = FocusNode();
  final FocusNode registerConfirmPasswordFocusNode = FocusNode();

  final TextEditingController registerInviteCodeController =
      TextEditingController();
  final FocusNode registerInviteCodeFocusNode = FocusNode();

  final TextEditingController corporateCodeController = TextEditingController();
  final FocusNode corporateCodeFocusNode = FocusNode();

  String? registerGender;
  bool corporateCodeStatus = false;

  setEditValues() {
    registerFirstNameController.text = currentUser!.firstName;
    registerLastNameController.text = currentUser!.lastName;
    registerGender = currentUser!.gender;
    dobController.text = currentUser!.dob;
    profileMobileNumber.text = currentUser!.mobile.toString();
    updateCorporateCodeController.text = currentUser!.corporateCode ?? '';
    corporateCodeStatus = currentUser!.activeCorporateCode;
  }

  clearFormFields() {
    registerFirstNameController.clear();
    registerPasswordController.clear();
    registerEmailController.clear();
    registerCnicController.clear();
    loginPasswordController.clear();
    registerInviteCodeController.clear();

    registerGender = null;
    registerPhoneController.clear();

    loginPhoneController.clear();
    registerConfirmPasswordController.clear();
    corporateCodeController.clear();
  }

  clearFindAccountController() {
    findAccountController.clear();
  }

  //use cases calls
  Future<void> loginUser() async {
    loginLoading.value = true;
    DeviceInfoService deviceInfoService = sl();

    final token = await PushNotifcationService().getToken();
    final deviceId = await deviceInfoService.getUniqueDeviceId();
    var params = LoginRequestModel(
        mobile: loginPhoneController.text.formatPhone(),
        password: loginPasswordController.text,
        fcmToken: token!,
        deviceId: deviceId);
    Logger().v(params.toJson());
    var loginEither = await _loginUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      loginLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        OtpProvider otp = sl();

        currentUser = response.data;

        await ClearAllNotifications.clear();

        if (currentUser!.selectedUserType == '1') {
          if (currentUser!.emailVerified && currentUser!.mobileVerified) {
            otp.emailVerified = currentUser!.emailVerified;
            otp.phoneVerified = currentUser!.mobileVerified;
            await PushNotifcationService.joinRooms();
            if (currentUser!.documentUpload == false) {
              goToPage(PageConfigs.driverDocumentVerification);
              loginLoading.value = false;
              return;
            } else if (currentUser!.documentUpload &&
                currentUser!.documentVerified.status == 'pending') {
              loginLoading.value = false;

              _showConfirmation();
              return;

              return ShowSnackBar.show(
                  'Your documents are being verified, please wait!');
            }
            if (currentUser!.documentUpload &&
                currentUser!.documentVerified.status == 'rejected') {
              loginLoading.value = false;

              ShowSnackBar.show(
                  'Your documents were rejected please upload new documents');
              goToPage(PageConfigs.driverDocumentVerification);
              return;
            }

            clearFormFields();
            if (await LocationApi.checkPermissions() || Platform.isIOS) {
              await updateUserOnDisk();
              loginLoading.value = false;

              goToPage(PageConfigs.dashboardPageConfig,
                  pageState: PageState.replaceAll);
            } else {
              goToPage(PageConfigs.locationPermissionPageConfig,
                  pageState: PageState.replaceAll);
            }
          } else {
            otp.byDefaultSmsOtp = currentUser!.mobileVerified;
            otp.byDefaultEmailOtp = currentUser!.emailVerified;
            otp.emailVerified = currentUser!.emailVerified;
            otp.phoneVerified = currentUser!.mobileVerified;
            otp.canResend = true;
            otp.resetCounter();
            loginLoading.value = false;

            goToPage(PageConfigs.driverOtpPageConfig,
                pageState: PageState.addPage);
          }
        } else {
          if (currentUser!.mobileVerified) {
            await PushNotifcationService.joinRooms();

            await updateUserOnDisk();
            loginLoading.value = false;
            clearFormFields();

            goToPage(PageConfigs.dashboardPageConfig,
                pageState: PageState.replaceAll);
          } else {
            otp.canResend = true;
            otp.resetCounter();
            loginLoading.value = false;

            goToPage(PageConfigs.userOtpPageConfig,
                pageState: PageState.addPage);
          }
        }
      });
    }
  }

  Future<void> resetPassword() async {
    resetPasswordLoading.value = true;

    var params = ResetPasswordRequestModel(
        mobile: fromProfileScreen
            ? currentUser!.mobile.toString()
            : findAccountController.text.formatPhone(),
        password: resetConfirmPasswordController.text);

    var loginEither = await _resetPasswordUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      resetPasswordLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        ShowSnackBar.show('Password reset successfully');
        AppState appState = sl();
        appState.moveToBackScreen();
        resetConfirmPasswordController.clear();
        findAccountController.clear();
        resetPasswordController.clear();

        resetPasswordLoading.value = false;
      });
    }
  }

  Future<void> deleteAccount(String password) async {
    deleteAccountLoading.value = true;

    var params =
        DeleteAccountRequestModel(userId: currentUser!.id, password: password);

    var loginEither = await _deleteAccountUsecase(params);

    if (loginEither.isLeft()) {
      deleteAccountLoading.value = false;

      handleError(loginEither);
      resetPasswordLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        ShowSnackBar.show(response.msg);
        AppState appState = sl();
        FlutterSecureStorage _secureStorage = sl();
        _secureStorage.delete(key: 'user');
        appState.goToNext(PageConfigs.selectUserPageConfig,
            pageState: PageState.replaceAll);
        deleteAccountLoading.value = false;
      });
    }
  }

  Future<void> registerUser() async {
    registerLoading.value = true;
    String gender = 'male';
    if (registerCnicController.text.isEmpty) {
      gender = 'male';
    } else {
      gender = int.parse(registerCnicController
                  .text[registerCnicController.text.length - 1])
              .isEven
          ? 'female'
          : 'male';
    }

    DeviceInfoService deviceInfoService=sl();
    final token = await PushNotifcationService().getToken();
    final deviceId = await deviceInfoService.getUniqueDeviceId();

    var params = RegisterRequestModel(
        inviteCode: registerInviteCodeController.text.isEmpty
            ? null
            : registerInviteCodeController.text,
        corporateCode: corporateCodeController.text.isEmpty
            ? null
            : corporateCodeController.text.trim(),
        firstName: registerFirstNameController.text.trim(),
        lastName: registerLastNameController.text.trim(),
        userType: getUserType(),
        mobile: registerPhoneController.text.formatPhone(),
        email: registerEmailController.text,
        password: registerPasswordController.text,
        gender: gender,
        cnic: registerCnicController.text.isEmpty
            ? '0'
            : registerCnicController.text,
        fcmToken: token!,
        deviceId:deviceId);

    var loginEither = await _registerUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      registerLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        currentUser = response.data;

        notifyListeners();
        registerLoading.value = false;
        // clearFormFields();
        OtpProvider otpProvider = sl();
        otpProvider.canResend = false;
        otpProvider.resetCounter();
        otpProvider.emailVerified = false;
        otpProvider.phoneVerified = false;
        ShowSnackBar.show('User registered successfully');
        if (userType == UserType.driver) {
          goToPage(PageConfigs.driverOtpPageConfig);
        } else {
          goToPage(PageConfigs.userOtpPageConfig);
        }
      });
    }
  }

  resetSignUpFields() {
    registerFirstNameController.clear();
    registerLastNameController.clear();
    registerPhoneController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    registerCnicController.clear();
    registerInviteCodeController.clear();
    registerGender = null;
    registerConfirmPasswordController.clear();
    corporateCodeController.clear();
  }

  resetSigninFields() {
    loginPasswordController.clear();
    loginPhoneController.clear();
  }

  /// find account
  Future<void> findAccount() async {
    findAccountLoading.value = true;

    var params = FindAccountRequestModel(
      mobile: fromProfileScreen
          ? currentUser!.mobile.toString()
          : findAccountController.text.formatPhone(),
    );

    var loginEither = await _findAccountUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      findAccountLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        ShowSnackBar.show('OTP sent');
        OtpProvider otpProvider = sl();
        findAccountLoading.value = false;
        otpProvider.canResend = false;
        otpProvider.resetValues();
        otpProvider.otpResetType = OtpResetType.findAccount;
        otpProvider.resetPasswordOtpControler.clear();
        goToPage(PageConfigs.resetPasswordOtpScreenPageConfig,
            pageState: PageState.replace);
      });
    }
  }

  //driver document upload screen
  chooseDocumentVerificationImage(
    bool isFrontSize,
  ) async {
    try {
      final file = await FileUtil.getImage(ImageSource.camera, quality: 70);
      if (isFrontSize) {
        frontSideImage = file;
        notifyListeners();
      } else {
        backSideImage = file;
        notifyListeners();
      }
    } catch (e) {} // no action required
  }

  clearDocumentUploadFiles() {
    frontSideImage = null;
    backSideImage = null;
  }

  Future<void> driverDocumentUpload() async {
    uploadVerificationDocumentLoading.value = true;

    final frontSideBase64 = FileUtil.encodeToBase64(frontSideImage);
    final backSideBase64 = FileUtil.encodeToBase64(backSideImage);
    final userId = currentUser!.id;

    var params = DriverDocumentUploadRequestModel(
        userId: userId, document: [frontSideBase64!, backSideBase64!]);

    var loginEither = await _driverDocumentUploadUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      uploadVerificationDocumentLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        uploadVerificationDocumentLoading.value = false;
        AppState appState = sl();
        resetSignUpFields();
        // ShowSnackBar.show('Your identity verification is in progress');
        _showConfirmation();
      });
    }
  }

  _showConfirmation() {
    ConfirmationDialog confirmationModal = ConfirmationDialog(
        navigatorKeyGlobal.currentContext!, leftTap: () {
      onBackPress = null;
      AuthProvider authProvider = sl();
      authProvider.logout();
    }, rightTap: () {
      onBackPress = null;
      DashboardProvider driverProvider = sl();
      driverProvider.switchRole();
    },
        leftTitle: 'Signout',
        rightTitle: 'Passenger',
        title: 'Documents Uploaded',
        details:
            "You identity verification is in progress. Do you want to signout or switch to passenger?");
    confirmationModal.show();
  }

  Future updateUserOnDisk() async {
    OtpProvider otpProvider = sl();
    otpProvider.resetValues();
    SecureStorageService storageService = SecureStorageService();
    await storageService.write(
        key: 'user', value: jsonEncode(currentUser!.toJson()));
  }

  Future<void> updateProfileImage(File file) async {
    final encodedImage = FileUtil.encodeToBase64(file);
    if (encodedImage == null) {
      return ShowSnackBar.show(
          'Invalid image data, please choose another image');
    }
    updateProfileImageLoading.value = true;
    var params = AddProfileImageRequestModel(
        userId: currentUser!.id, file: encodedImage);

    var loginEither = await _updateProfileImageUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      updateProfileImageLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        currentUser = response.data;
        await updateUserOnDisk();
        notifyListeners();
        updateProfileImageLoading.value = false;
        ShowSnackBar.show('Profile image updated successfully!');
      });
    }
  }

  Future<void> updateSelectedVehicle({required String id}) async {
    updateSelectedVehicleLoading.value = true;
    var params = UpdateSelectedVehicleRequestModel(
        userId: currentUser!.id, vehicleId: id);

    var loginEither = await _updateSelectedVehicleUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      updateSelectedVehicleLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        ShowSnackBar.show(response.msg);
        currentUser!.selectedVehicle = id;
        await updateUserOnDisk();
        notifyListeners();
        updateSelectedVehicleLoading.value = false;
      });
    }
  }

  Future<void> updateProfile() async {
    updateProfileLoading.value = true;
    var params = UpdateProfileRequestModel(
        userId: currentUser!.id,
        firstName: registerFirstNameController.text.trim(),
        lastName: registerLastNameController.text.trim(),
        activeCorporateCode: corporateCodeStatus,
        corporateCode: updateCorporateCodeController.text,
        // gender: registerGender!,
        dob: dobController.text);

    var loginEither = await _updateProfileUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      updateProfileLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        ShowSnackBar.show(response.msg);
        currentUser = response.data;
        await updateUserOnDisk();
        notifyListeners();
        updateProfileLoading.value = false;
        AppState appState = sl();
        appState.moveToBackScreen();
        // appState.removePage(PageConfigs.profileScreenPageConfig);
        DashboardProvider dashboardProvider = sl();
        dashboardProvider.dashboardScaffoldKey.currentState!.closeDrawer();

        Timer(const Duration(milliseconds: 200), () {
          appState.moveToBackScreen();
        });
      });
    }
  }

  Future<void> getUserProfile() async {
    var params = GetUserProfileRequestModel(
      userId: currentUser!.id,
    );

    var loginEither = await _getUserProfileUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        currentUser = response.data;
        if (!currentUser!.active.status) {
          FlutterSecureStorage storage = sl();
          await storage.delete(key: 'user');
          Timer(const Duration(milliseconds: 600), () {
            AppState appState = sl();
            appState.goToNext(PageConfigs.selectUserPageConfig,
                pageState: PageState.replaceAll);
          });
          currentUser = null;
          if (currentUser != null) {
            ShowSnackBar.show(currentUser!.active.comment);
          }
          return;
        }

        SecureStorageService storageService = SecureStorageService();
        await storageService.write(
            key: 'user', value: jsonEncode(currentUser!.toJson()));
        notifyListeners();
      });
    }
  }

  Future<void> newNumberAvailbleCheck({bool isResent=false}) async {
    AuthProvider authProvider = sl();
    newNumberAvailbleCheckLoading.value = true;
    var params = NewNumberAvailableCheckRequestModel(
        mobile: findAccountController.text.formatPhone(),
        userId: authProvider.currentUser!.id);

    var loginEither = await _newNumberAvailbleCheckUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      newNumberAvailbleCheckLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        OtpProvider otpProvider = sl();
        otpProvider.canResend = false;
        newNumberAvailbleCheckLoading.value = false;
        if(isResent){
          ShowSnackBar.show('OTP resent');
          OtpProvider otpProvider=sl();
          otpProvider.resetCounter();

        }else{
          AppState appState = sl();
          appState.goToNext(PageConfigs.resetPasswordOtpScreenPageConfig);
        }


      });
    }
  }

  logout() async {
    FlutterSecureStorage secureStorage = sl();
    secureStorage.delete(key: 'user');
    Loading.show(message: 'Loging out');
    var params = LogoutRequestModel(
      userId: currentUser!.id,
    );

    var loginEither = await _logoutUsecase(params);

    if (loginEither.isLeft()) {
      Loading.dismiss();
      handleError(loginEither);
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        FlutterSecureStorage secureStorage = sl();
        secureStorage.delete(key: 'user');
        await PushNotifcationService.leaveRooms();
        await ClearAllNotifications.clear();
        await BackgroundLocationService.stop();

        VehicleProvider vehicleProvider = sl();
        vehicleProvider.getUserVehiclesResponseModel = null;
        ScheduleProvider scheduleProvider = sl();
        scheduleProvider.getSchedulesResponseModel = null;
        scheduleProvider.getDriversListResponseModel = null;
        scheduleProvider.getRequestedPassengerResponseModel = null;
        scheduleProvider.getPassengerSchdulesResponseModel = null;
        SystemNotificationsProvider systemNotificationsProvider = sl();
        systemNotificationsProvider.getNotificationsResponseModel = null;

        SocketService.close();
        Loading.dismiss();

        goToPage(PageConfigs.selectUserPageConfig,
            pageState: PageState.replaceAll);
      });
    }
  }

  goToPage(PageConfiguration configuration,
      {PageState pageState = PageState.addPage}) {
    AppState appState = GetIt.I.get<AppState>();
    appState.currentAction = PageAction(state: pageState, page: configuration);
  }

  // form Handler

  bool isDataChanged() {
    AuthProvider authProvider = sl();

    if (registerFirstNameController.text.toLowerCase().trim() !=
            authProvider.currentUser!.firstName.toLowerCase().trim() ||
        registerLastNameController.text.toLowerCase().trim() !=
            authProvider.currentUser!.lastName.toLowerCase().trim() ||
        dobController.text != authProvider.currentUser!.dob.trim() ||
        updateCorporateCodeController.text !=
            authProvider.currentUser!.corporateCode) {
      return true;
    }

    return false;
  }

  resetResetPasswordController(){
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
  }

  bool validateRegisterOthers() {

    return false;
    if (registerGender == null) {
      ShowSnackBar.show('Gender is empty');
      return true;
    } else {
      return false;
    }
  }

  callNotifi() {
    notifyListeners();
  }

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }

  String getUserType() {
    if (userType == UserType.driver) {
      return '1';
    } else {
      return '2';
    }
  }
}

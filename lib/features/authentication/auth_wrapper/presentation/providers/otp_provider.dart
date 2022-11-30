import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/extension/extensions.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/update_mobile_number_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/domain/usecases/update_mobile_number_usecase.dart';
import 'package:flutter_rideshare/features/ride/presentation/providers/driver_ride_provider.dart';
import 'package:flutter_rideshare/features/splash_screen/presentation/providers/splash_provider.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/link_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/router/app_state.dart';
import '../../../../../core/router/models/page_action.dart';
import '../../../../../core/router/models/page_config.dart';
import '../../../../../core/router/pages.dart';
import '../../../../../core/utils/enums/otp_reset_enum.dart';
import '../../../../../core/utils/enums/page_state_enum.dart';
import '../../../../../core/utils/globals/globals.dart';
import '../../../../../core/utils/globals/snake_bar.dart';
import '../../../../../core/utils/location/location_api.dart';
import '../../data/models/email_verify_request_model.dart';
import '../../data/models/find_account_request_model.dart';
import '../../data/models/mobile_verify_request_model.dart';
import '../../data/models/resend_otp_request_model.dart';
import '../../domain/usecases/find_account_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_email_otp_usecase.dart';
import '../../domain/usecases/verify_phone_otp_usecase.dart';
import 'auth_provider.dart';

class OtpProvider extends ChangeNotifier {
  OtpProvider(
      this._verifyPhoneUsecase,
      this._verifyEmailUsecase,
      this._resendOtpUsecase,
      this._resendResetPasswordOtp,
      this._updateMobileNumberUsecase,
      this._linkZindigiAccountUsecase);

  // value notifiers

  ValueNotifier<bool> otpLoading = ValueNotifier(false);

  // screen properties
  final StreamController<ErrorAnimationType> phoneOtpErrorStream =
      StreamController<ErrorAnimationType>.broadcast();

  final StreamController<ErrorAnimationType> emailOtpErrorStream =
      StreamController<ErrorAnimationType>.broadcast();

  // TextEditingController emailOtpController = TextEditingController();
  // TextEditingController mobileOtpController = TextEditingController();
  TextEditingController resetPasswordOtpControler = TextEditingController();
  TextEditingController passwordOtpController = TextEditingController();

  OtpResetType otpResetType = OtpResetType.resetPassword;
  bool emailVerified = false;
  bool phoneVerified = false;
  bool byDefaultEmailOtp = false;
  bool byDefaultSmsOtp = false;

  bool linkZindigiAccountOtp = false;

  final AuthProvider _authProvider = sl();

  //resend otp
  int counter = 90 + 1;
  bool canResend = false;
  Timer? resendTimer;

  resendOtpCounter() {
    stopTimerIfActive();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      logCounter();

      counter = counter - 1;
      if (counter < 1) {
        timer.cancel();
        canResend = true;
      }
      notifyListeners();
    });
  }

  stopTimerIfActive() {
    if (resendTimer != null) {
      if (resendTimer!.isActive) {
        resendTimer!.cancel();
      }
    }
  }

  //It is resetting variables counter and canResend to starting position
  resetCounter() {
    canResend = false;
    counter = 90 + 1;
    resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      logCounter();
      counter = counter - 1;
      if (counter == 0) {
        timer.cancel();
        canResend = true;
      }
      notifyListeners();
    });

    notifyListeners();
  }
//usecases

  final VerifyEmailUsecase _verifyEmailUsecase;
  final VerifyPhoneUsecase _verifyPhoneUsecase;
  final LinkZindigiAccountUsecase _linkZindigiAccountUsecase;
  final UpdateMobileNumberUsecase _updateMobileNumberUsecase;
  final ResendOtpUsecase _resendOtpUsecase;
  final FindAccountUsecase _resendResetPasswordOtp;

//use cases calls

  validatePhoneOtp(String pin) async {
    otpLoading.value = true;

    AuthProvider _authProvider = sl();
    var params = MobileVerifyRequestModel(
        mobile: _authProvider.currentUser!.mobile.toString(), mobileOTP: pin);

    var loginEither = await _verifyPhoneUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        _authProvider.currentUser!.mobileVerified = true;
        otpLoading.value = false;
        phoneVerified = true;
        if (_authProvider.currentUser!.selectedUserType == '1') {
          if (phoneVerified && emailVerified) {
            clearFields();

            SplashProvider splashProvider = sl();
            splashProvider.moveToLogin = true;
            goToNext(PageConfigs.driverDocumentVerification,
                pageState: PageState.replace);

            // storeAndGoToNext();
            stopTimerIfActive();
          }
        } else {
          if (phoneVerified) {
            storeAndGoToNext();
            stopTimerIfActive();
          }
        }

        notifyListeners();
        ShowSnackBar.show('Phone OTP verified');
      });
    }
  }

  validateEmailOtp(String otp) async {
    otpLoading.value = true;

    var params = EmailVerifyRequestModel(
        email: _authProvider.currentUser!.email.toString(), emailOTP: otp);

    var loginEither = await _verifyEmailUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        otpLoading.value = false;
        emailVerified = true;

        _authProvider.currentUser!.emailVerified = true;
        if (phoneVerified && emailVerified) {
          SplashProvider splashProvider = sl();
          splashProvider.moveToLogin = true;
          // storeAndGoToNext();

          clearFields();
          goToNext(PageConfigs.driverDocumentVerification,
              pageState: PageState.replace);
          stopTimerIfActive();
        }
        notifyListeners();
        ShowSnackBar.show('Email OTP verified');
      });
    }
  }

  validateResetPasswordOtp(String otp) async {
    otpLoading.value = true;

    AuthProvider _authProvider = sl();
    var params = MobileVerifyRequestModel(
        mobile: _authProvider.fromProfileScreen
            ? _authProvider.currentUser!.mobile.toString()
            : _authProvider.findAccountController.text.formatPhone(),
        mobileOTP: otp);

    var loginEither = await _verifyPhoneUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        otpLoading.value = false;
        goToNext(PageConfigs.resetPasswordScreenPageConfig,
            pageState: PageState.replace);
      });
    }
  }

  Future<void> linkZindigiAccount(String otp) async {
    otpLoading.value = true;
    AuthProvider authProvider = sl();

    var params = LinkZindigiAccountRequestModel(
        dateTime: DateTime.now().toString(),
        cnic: authProvider.currentUser!.cnic.toString(),
        mobileNo: authProvider.currentUser!.mobile.toString(),
        otpPin: otp,
        userId: authProvider.currentUser!.id);

    var loginEither = await _linkZindigiAccountUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        AppState appState = sl();
        appState.removePage(PageConfigs.linkZindigiAccountPageConfig);
        WalletProvider walletProvider = sl();
        await walletProvider.getWalletInfo(reCall: true);

        ShowSnackBar.show(response.msg);
        otpLoading.value = false;

        appState.moveToBackScreen();
      });
    }
  }

  updateMobileNumber(String otp) async {
    otpLoading.value = true;

    AuthProvider _authProvider = sl();
    var params = UpdateMobileNumberRequestModel(
        mobile: _authProvider.findAccountController.text.formatPhone(),
        OTP: int.parse(otp),
        userId: _authProvider.currentUser!.id);

    var loginEither = await _updateMobileNumberUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        AppState appState = sl();
        appState.removePage(PageConfigs.findAccountScreenPageConfig);
        await Future.delayed(Duration(milliseconds: 300));
        appState.removePage(PageConfigs.resetPasswordOtpScreenPageConfig);
        await Future.delayed(Duration(milliseconds: 300));
        ShowSnackBar.show(response.msg);
        AuthProvider authProvider = sl();
        authProvider.currentUser = response.data;
        await authProvider.updateUserOnDisk();
        appState.moveToBackScreen();
        notifyListeners();
        otpLoading.value = false;
        ShowSnackBar.show(response.msg);
      });
    }
  }

  logCounter() {
    // Logger().v(counter.toString());
  }

  resendOtp(BuildContext context) async {
    otpLoading.value = true;
    AuthProvider authProvider = sl();
    FocusScope.of(context).unfocus();

    var params = ResendOtpRequestModel(
        userId: authProvider.currentUser!.id,
        token: authProvider.currentUser!.token);

    var loginEither = await _resendOtpUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        resetCounter();
        otpLoading.value = false;

        notifyListeners();
        ShowSnackBar.show('OTP resent');
      });
    }
  }

  Future<void> resendResetPasswordOtp(BuildContext context) async {
    otpLoading.value = true;
    AuthProvider authProvider = _authProvider;
    FocusScope.of(context).unfocus();
    OtpProvider otpProvider = sl();
    bool isCompleteRide = otpProvider.otpResetType == OtpResetType.completeRide;
    WalletProvider walletProvider = sl();

    var params = FindAccountRequestModel(
      mobile: isCompleteRide
          ? walletProvider.completePassengerMobile
          : authProvider.fromProfileScreen || linkZindigiAccountOtp
              ? authProvider.currentUser!.mobile.toString()
              : authProvider.findAccountController.text.formatPhone(),
    );

    var loginEither = await _resendResetPasswordOtp(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      otpLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        resetCounter();
        otpLoading.value = false;

        notifyListeners();
        ShowSnackBar.show('OTP resent');
      });
    }
  }

  storeAndGoToNext() async {
    AuthProvider _authProvider = sl();
    FlutterSecureStorage secureStorage = sl();

    if (await LocationApi.checkPermissions() || Platform.isIOS) {
      await secureStorage.write(
          key: 'user', value: jsonEncode(_authProvider.currentUser!.toJson()));

      goToNext(PageConfigs.introductionPageConfig,
          pageState: PageState.replaceAll);
    } else {
      goToNext(PageConfigs.locationPermissionPageConfig,
          pageState: PageState.replaceAll);
    }
  }

  // Methods
  void onPhoneOtpCompleted(String value) {
    validatePhoneOtp(value);
  }

  void onRestPasswordOtpChange(String value) {
    Logger().v(otpResetType);
    if (value.length == 4) {
      if (otpResetType == OtpResetType.resetPassword) {
        validateResetPasswordOtp(value);
      } else if (otpResetType == OtpResetType.linkZindigiAccount) {
        linkZindigiAccount(value);
      } else if (otpResetType == OtpResetType.updateMobile) {
        updateMobileNumber(value);
        // validateResetPasswordOtp(value);
      } else if (otpResetType == OtpResetType.findAccount) {
        validateResetPasswordOtp(value);
      } else if (otpResetType == OtpResetType.unlinkZindigiAccount) {
        WalletProvider walletProvider = sl();
        walletProvider.unlinkZindigiAccount(value);
      } else if (otpResetType == OtpResetType.completeRide) {
        DriverRideProvider driverRideProvider = sl();
        WalletProvider otpProvider = sl();
        driverRideProvider.completeRide(navigatorKeyGlobal.currentContext!,
            scheduleId: otpProvider.completeScheduleId, otp: value);
      }
    }
  }

  void onEmailOtpCompleted(String value) {
    validateEmailOtp(value);
  }

  void onChanged(String value) {
    if (value.length == 4) {
      Logger().v(value);
      validateEmailOtp(value);
    }
  }

  goToNext(PageConfiguration pageConfigs,
      {PageState pageState = PageState.addPage}) {
    AppState appState = GetIt.I.get<AppState>();
    appState.currentAction = PageAction(
      state: pageState,
      page: pageConfigs,
    );
  }

//error handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }

//clearing fields

  clearFields() {
    // emailOtpController.clear();
    // mobileOtpController.clear();
    if (resendTimer != null) {
      resendTimer!.cancel();
      resendTimer = null;
    }
    counter = 90;
    canResend = false;
  }

  resetValues() {
    counter = 90;
    canResend = false;
    emailVerified = false;
    phoneVerified = false;
    byDefaultEmailOtp = false;
    byDefaultSmsOtp = false;
  }
}

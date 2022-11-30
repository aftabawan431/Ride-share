import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/router/app_state.dart';
import 'package:flutter_rideshare/core/router/models/page_config.dart';
import 'package:flutter_rideshare/core/utils/encryption/encryption.dart';
import 'package:flutter_rideshare/core/utils/sockets/sockets.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:flutter_rideshare/features/wallet/data/models/create_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/unlink_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/zindigi_wallet_otp.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/create_zindigi_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/get_wallet_info_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/link_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/unlink_zindigi_account_usecase.dart';
import 'package:flutter_rideshare/features/wallet/domain/use_cases/validate_zindigi_accont_usecase.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/modals/no_params.dart';
import '../../../../core/utils/enums/otp_reset_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';
import '../../../authentication/auth_wrapper/domain/usecases/get_sim_provider_usecase.dart';
import '../../data/models/validate_zindigi_account_request_model.dart';
import '../../domain/use_cases/zindigi_wallet_otp.dart';

class WalletProvider extends ChangeNotifier {
  ValueNotifier<bool> getSimProvidersLoading = ValueNotifier(false);

  //usecases
  final GetWalletInfoUsecase _getWalletInfoUsecase;
  final LinkZindigiAccountUsecase _linkZindigiAccountUsecase;
  final UnlinkZindigiAccountUsecase _unlinkZindigiAccountUsecase;
  final ValidateZindigiAccountUsecase _validateZindigiAccountUsecase;
  final GetSimProviderUsecase _getSimProviderUsecase;
  final CreateZindigiAccountUsecase _createZindigiAccountUsecase;
  final ZindgiWalletOtpUsecase _zindgiWalletOtpUsecase;

  WalletProvider(
      this._validateZindigiAccountUsecase,
      this._linkZindigiAccountUsecase,
      this._getWalletInfoUsecase,
      this._getSimProviderUsecase,
      this._createZindigiAccountUsecase,
      this._unlinkZindigiAccountUsecase,
      this._zindgiWalletOtpUsecase);

  //loading notifiers

  ValueNotifier<bool> getWalletInfoLoading = ValueNotifier(false);
  ValueNotifier<bool> accountLoading = ValueNotifier(false);
  ValueNotifier<bool> linkingLoading = ValueNotifier(false);

  //properties
  GetWalletInfoResponseModel? getWalletInfoResponseModel;
  GetSimProvidersResponseModel? getSimProvidersResponseModel;

  String completeScheduleId='';
  String compeletePassengerId='';
  String completePassengerMobile='';

  //usecases calls
  Future<void> getWalletInfo({bool reCall = false}) async {
    if (getWalletInfoResponseModel != null) {
      if (!reCall) {
        return;
      }
    }

    getWalletInfoLoading.value = true;
    AuthProvider authProvider = sl();

    var params =
        GetWalletInfoRequestModel(userId: authProvider.currentUser!.id);

    var loginEither = await _getWalletInfoUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getWalletInfoLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        getWalletInfoResponseModel = response;
        notifyListeners();
        getWalletInfoLoading.value = false;
      });
    }
  }

  Future<void> getSimProviders() async {
    if (getSimProvidersResponseModel != null) {
      return;
    }

    getSimProvidersLoading.value = true;

    var loginEither = await _getSimProviderUsecase(NoParams());

    if (loginEither.isLeft()) {
      handleError(loginEither);
      getSimProvidersLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        getSimProvidersResponseModel = response;
        getSimProvidersLoading.value = false;
      });
    }
  }

  Future<void> createZindigiAccount({
    required String cnicIssuanceDate,
    required String mobileNetwork,
  }) async {
    accountLoading.value = true;
    AuthProvider authProvider = sl();
    final params = CreateZindigiAccountRequestModel(
        dateTime: DateTime.now().toString(),
        mobileNo: authProvider.currentUser!.mobile.toString(),
        cnic: authProvider.currentUser!.cnic.toString(),
        cnicIssuanceDate: cnicIssuanceDate,
        mobileNetwork: mobileNetwork,
        emailId: authProvider.currentUser!.email,
        userId: authProvider.currentUser!.id);

    var loginEither = await _createZindigiAccountUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      accountLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) {
        ShowSnackBar.show(response.msg);
        getWalletInfo(reCall: true);
        AppState appState = sl();
        appState.moveToBackScreen();
        accountLoading.value = false;
      });
    }
  }

  Future<void> validateZindigiAccount() async {
    linkingLoading.value = true;
    AuthProvider authProvider = sl();

    var params = ValidateZindigiAccountRequestModel(
      cnic: authProvider.currentUser!.cnic.toString(),
      userId: authProvider.currentUser!.id,
      dateTime: DateTime.now().toString(),
      mobileNo: authProvider.currentUser!.mobile.toString(),
    );
    Logger().v(params.toJson());

    var loginEither = await _validateZindigiAccountUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);
      if (kStatusCode == 403) {
        kStatusCode = 0;
        AppState appState = sl();
        appState.goToNext(PageConfigs.createZindigiAccountPageConfig);
      }
      linkingLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        kStatusCode = 0;
        AuthProvider authProvider = sl();
        authProvider.isFindAccount = false;
        OtpProvider otpProvider = sl();
        otpProvider.otpResetType = OtpResetType.linkZindigiAccount;
        otpProvider.linkZindigiAccountOtp = true;
        otpProvider.canResend = false;
        AppState appState = sl();
        appState.goToNext(PageConfigs.resetPasswordOtpScreenPageConfig);
        linkingLoading.value = false;
      });
    }
  }

  Future<void> unlinkZindigiAccount(String otp) async {
    linkingLoading.value = true;
    AuthProvider authProvider = sl();

    var params = UnlinkZindigiAccountRequestModel(
        userId: authProvider.currentUser!.id, OTP: int.parse(otp));

    var loginEither = await _unlinkZindigiAccountUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);

      linkingLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        ShowSnackBar.show(response.msg);
        AppState appState=sl();
        appState.moveToBackScreen();

        linkingLoading.value = false;
        getWalletInfo(reCall: true);
      });
    }
  }

  Future<void> zindigiWalletOtp() async {
    accountLoading.value = true;
    AuthProvider authProvider = sl();

    var params = ZindigWalletOtpRequestModel(
      userId: authProvider.currentUser!.id,
    );

    var loginEither = await _zindgiWalletOtpUsecase(params);

    if (loginEither.isLeft()) {
      handleError(loginEither);

      accountLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        kStatusCode = 0;
        OtpProvider otpProvider = sl();
        otpProvider.canResend = false;
        AppState appState = sl();
        appState.goToNext(PageConfigs.resetPasswordOtpScreenPageConfig);
        accountLoading.value = false;
      });
    }
  }

  sendCompleteRideOtp(String passengerId,{bool isResend=false})async{
    final encrypted=Encryption.encryptObject(jsonEncode({'passengerId':passengerId}));
    SocketService.socket!.emitWithAck('sendCompleteRideOTP',jsonEncode(encrypted),ack: (data){
      ShowSnackBar.show('OTP sent');
      if(isResend==false){
        AppState appState = sl();

        appState.goToNext(PageConfigs.resetPasswordOtpScreenPageConfig);

      }



    });
  }

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }
}

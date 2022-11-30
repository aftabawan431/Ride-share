import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/create_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/validate_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/zindigi_wallet_otp.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/get_wallet_info_request_model.dart';
import '../../data/models/get_wallet_info_response_model.dart';
import '../../data/models/unlink_zindigi_account_request_model.dart';

abstract class WalletRepository {
  Future<Either<Failure, GetWalletInfoResponseModel>> getWalletInfo(
      GetWalletInfoRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> validateZindigiAccount(
      ValidateZindigiAccountRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> linkZindigiAccount(
      LinkZindigiAccountRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> createZindigiAccount(
      CreateZindigiAccountRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> unlinkZindigiAccount(
      UnlinkZindigiAccountRequestModel params);

  Future<Either<Failure, SuccessResponseModel>> zindigiWalletOtp(
      ZindigWalletOtpRequestModel params);



}



import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/validate_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/zindigi_wallet_otp.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';

class ZindgiWalletOtpUsecase
    extends UseCase<SuccessResponseModel, ZindigWalletOtpRequestModel> {
  WalletRepository ZindigiWalletOtpUsecase;
  ZindgiWalletOtpUsecase(this.ZindigiWalletOtpUsecase);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(
      ZindigWalletOtpRequestModel params) async {
    return await ZindigiWalletOtpUsecase.zindigiWalletOtp(params);
  }
}

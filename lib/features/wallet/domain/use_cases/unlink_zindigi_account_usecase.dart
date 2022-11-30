import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/unlink_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';

class UnlinkZindigiAccountUsecase
    extends UseCase<SuccessResponseModel, UnlinkZindigiAccountRequestModel> {
  WalletRepository repository;
  UnlinkZindigiAccountUsecase(this.repository);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(
      UnlinkZindigiAccountRequestModel params) async {
    return await repository.unlinkZindigiAccount(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/validate_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class ValidateZindigiAccountUsecase extends UseCase<SuccessResponseModel, ValidateZindigiAccountRequestModel> {
  WalletRepository repository;
  ValidateZindigiAccountUsecase(this.repository);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(ValidateZindigiAccountRequestModel params) async {
    return await repository.validateZindigiAccount(params);
  }
}
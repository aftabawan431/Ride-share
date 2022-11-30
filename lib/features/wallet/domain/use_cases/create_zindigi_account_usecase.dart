import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../data/models/create_zindigi_account_request_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class CreateZindigiAccountUsecase extends UseCase<SuccessResponseModel, CreateZindigiAccountRequestModel> {
  WalletRepository repository;
  CreateZindigiAccountUsecase(this.repository);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(CreateZindigiAccountRequestModel params) async {
    return await repository.createZindigiAccount(params);
  }
}

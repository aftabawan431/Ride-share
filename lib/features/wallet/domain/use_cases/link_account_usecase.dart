import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import 'package:flutter_rideshare/features/wallet/data/models/link_zindigi_account_request_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class LinkZindigiAccountUsecase extends UseCase<SuccessResponseModel, LinkZindigiAccountRequestModel> {
  WalletRepository repository;
  LinkZindigiAccountUsecase(this.repository);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(LinkZindigiAccountRequestModel params) async {
    return await repository.linkZindigiAccount(params);
  }
}

import 'package:dartz/dartz.dart';
import '../../data/models/delete_account_request_model.dart';
import '../../data/models/delete_account_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class DeleteAccountUsecase extends UseCase<DeleteAccountResponseModel, DeleteAccountRequestModel> {
  AuthRepository repository;
  DeleteAccountUsecase(this.repository);

  @override
  Future<Either<Failure, DeleteAccountResponseModel>> call(DeleteAccountRequestModel params) async {
    return await repository.deleteAccount(params);
  }
}

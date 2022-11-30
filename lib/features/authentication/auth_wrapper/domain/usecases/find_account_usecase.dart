import 'package:dartz/dartz.dart';
import '../../data/models/find_account_request_model.dart';
import '../../data/models/find_account_respnose_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class FindAccountUsecase extends UseCase<FindAccountResponseModel, FindAccountRequestModel> {
  AuthRepository repository;
  FindAccountUsecase(this.repository);

  @override
  Future<Either<Failure, FindAccountResponseModel>> call(FindAccountRequestModel params) async {
    return await repository.findAccount(params);
  }
}

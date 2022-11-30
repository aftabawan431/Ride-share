import 'package:dartz/dartz.dart';
import '../../data/models/logout_request_model.dart';
import '../../data/models/logout_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class LogoutUsecase extends UseCase<LogoutResponseModel, LogoutRequestModel> {
  AuthRepository repository;
  LogoutUsecase(this.repository);

  @override
  Future<Either<Failure, LogoutResponseModel>> call(LogoutRequestModel params) async {
    return await repository.logoutUser(params);
  }
}

import 'package:dartz/dartz.dart';
import '../../data/models/reset_password_request_model.dart';
import '../../data/models/reset_password_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class ResetPasswordUsecase extends UseCase<ResetPasswordResposeModel, ResetPasswordRequestModel> {
  AuthRepository repository;
  ResetPasswordUsecase(this.repository);

  @override
  Future<Either<Failure, ResetPasswordResposeModel>> call(ResetPasswordRequestModel params) async {
    return await repository.resetPassword(params);
  }
}

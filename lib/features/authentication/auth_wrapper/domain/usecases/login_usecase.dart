import 'package:dartz/dartz.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_modal.dart';



class LoginUsecase extends UseCase<LoginResponseModel, LoginRequestModel> {
  AuthRepository repository;
  LoginUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(LoginRequestModel params) async {
    return await repository.loginUser(params);
  }
}

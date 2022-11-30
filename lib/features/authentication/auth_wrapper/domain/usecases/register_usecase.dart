import 'package:dartz/dartz.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class RegisterUsecase extends UseCase<RegisterResponseModel, RegisterRequestModel> {
  AuthRepository repository;
  RegisterUsecase(this.repository);

  @override
  Future<Either<Failure, RegisterResponseModel>> call(RegisterRequestModel params) async {
    return await repository.registerUser(params);
  }
}

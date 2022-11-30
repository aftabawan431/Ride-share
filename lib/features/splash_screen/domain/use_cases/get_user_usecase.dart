import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../core/modals/no_params.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../repository/splash_repository.dart';




class GetUserUsecase extends UseCase<User, NoParams> {
  SplashRepository repository;
  GetUserUsecase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUser(params);
  }
}
import 'package:dartz/dartz.dart';
import '../../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../../../../authentication/auth_wrapper/domain/repository/auth_repo.dart';
import '../../data/model/update_profile_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class UpdateProfileUsecase extends UseCase<LoginResponseModel, UpdateProfileRequestModel> {
  AuthRepository repository;
  UpdateProfileUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(UpdateProfileRequestModel params) async {
    return await repository.updateProfile(params);
  }
}

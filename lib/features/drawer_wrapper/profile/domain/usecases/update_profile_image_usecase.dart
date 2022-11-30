import 'package:dartz/dartz.dart';

import '../../../../authentication/auth_wrapper/domain/repository/auth_repo.dart';
import '../../data/model/add_profile_image_request_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../authentication/auth_wrapper/data/models/login_response_modal.dart';




class UpdateProfileImageUsecase extends UseCase<LoginResponseModel, AddProfileImageRequestModel> {
  AuthRepository repository;
  UpdateProfileImageUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(AddProfileImageRequestModel params) async {
    return await repository.updateProfileImage(params);
  }
}

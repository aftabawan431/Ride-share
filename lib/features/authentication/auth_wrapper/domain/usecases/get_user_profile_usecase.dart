import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/no_params.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_user_profile_request_model.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetUserProfileUsecase extends UseCase<LoginResponseModel, GetUserProfileRequestModel> {
  AuthRepository repository;
  GetUserProfileUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(GetUserProfileRequestModel params) async {
    return await repository.getUserProfile(params);
  }
}

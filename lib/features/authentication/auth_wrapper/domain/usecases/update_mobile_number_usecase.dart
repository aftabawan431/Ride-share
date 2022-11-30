import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/update_mobile_number_request_model.dart';
import '../../data/models/login_response_modal.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class UpdateMobileNumberUsecase extends UseCase<LoginResponseModel, UpdateMobileNumberRequestModel> {
  AuthRepository repository;
  UpdateMobileNumberUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(UpdateMobileNumberRequestModel params) async {
    return await repository.updateMobileNumber(params);
  }
}

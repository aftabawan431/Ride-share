import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/success_response_model.dart';
import '../../data/models/change_number_available_check_request_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class NewNumberAvailbleCheckUsecase extends UseCase<SuccessResponseModel, NewNumberAvailableCheckRequestModel> {
  AuthRepository repository;
  NewNumberAvailbleCheckUsecase(this.repository);

  @override
  Future<Either<Failure, SuccessResponseModel>> call(NewNumberAvailableCheckRequestModel params) async {
    return await repository.newNumberAvailbleCheck(params);
  }
}

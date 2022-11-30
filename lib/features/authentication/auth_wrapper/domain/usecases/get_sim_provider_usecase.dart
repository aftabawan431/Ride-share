import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/core/modals/no_params.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/data/models/get_sim_providers_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetSimProviderUsecase extends UseCase<GetSimProvidersResponseModel, NoParams> {
  AuthRepository repository;
  GetSimProviderUsecase(this.repository);

  @override
  Future<Either<Failure, GetSimProvidersResponseModel>> call(NoParams params) async {
    return await repository.getSimProviders(params);
  }
}

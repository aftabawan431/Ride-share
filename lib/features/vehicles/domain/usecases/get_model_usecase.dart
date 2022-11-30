import 'package:dartz/dartz.dart';
import '../../data/models/get_models_request_model.dart';
import '../../data/models/get_models_response_model.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetModelsUsecase extends UseCase<GetModelsResponseModel, GetModelsRequestModel> {
  VehicleRepository repository;
  GetModelsUsecase(this.repository);

  @override
  Future<Either<Failure, GetModelsResponseModel>> call(GetModelsRequestModel params) async {
    return await repository.getModel(params);
  }
}

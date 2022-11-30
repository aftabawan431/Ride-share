import 'package:dartz/dartz.dart';
import '../../data/models/get_city_request_model.dart';
import '../../data/models/get_city_response_model.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetCityUsecase extends UseCase<GetCityResponseModel, GetCityRequestModel> {
  VehicleRepository repository;
  GetCityUsecase(this.repository);

  @override
  Future<Either<Failure, GetCityResponseModel>> call(GetCityRequestModel params) async {
    return await repository.getCity(params);
  }
}

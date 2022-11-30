import 'package:dartz/dartz.dart';
import '../../data/models/get_user_vehicles_request_model.dart';
import '../../data/models/get_user_vehicles_response_model.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetVehiclesUsecase extends UseCase<GetUserVehiclesResponseModel, GetUserVehicleRequestModel> {
  VehicleRepository repository;
  GetVehiclesUsecase(this.repository);

  @override
  Future<Either<Failure, GetUserVehiclesResponseModel>> call(GetUserVehicleRequestModel params) async {
    return await repository.getVehicles(params);
  }
}

import 'package:dartz/dartz.dart';
import '../../data/models/delete_vehicle_request_model.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/get_user_vehicles_response_model.dart';



class DeleteVehicleUsecase extends UseCase<GetUserVehiclesResponseModel, DeleteVehicleRequestModel> {
  VehicleRepository repository;
  DeleteVehicleUsecase(this.repository);

  @override
  Future<Either<Failure, GetUserVehiclesResponseModel>> call(DeleteVehicleRequestModel params) async {
    return await repository.deleteVehicle(params);
  }
}

import 'package:dartz/dartz.dart';
import '../../data/models/add_vehicle_request_model.dart';
import '../../data/models/add_vehicle_response_model.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class AddVehicleUsecase extends UseCase<AddVehicleResponseModel, AddVehicleRequestModel> {
  VehicleRepository repository;
  AddVehicleUsecase(this.repository);

  @override
  Future<Either<Failure, AddVehicleResponseModel>> call(AddVehicleRequestModel params) async {
    return await repository.addVehicle(params);
  }
}

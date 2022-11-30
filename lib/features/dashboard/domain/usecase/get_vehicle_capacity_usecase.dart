import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/model/GetVehicleCapacityRequestModel.dart';
import '../../data/model/get_vehicle_capacity_response_model.dart';
import '../repository/dashboard_repository.dart';




class GetVehicleCapacityUsecase extends UseCase<GetVehicleCapacityResponseModel, GetVehicleCapacityRequestModel> {
  DashboardRepository repository;
  GetVehicleCapacityUsecase(this.repository);

  @override
  Future<Either<Failure, GetVehicleCapacityResponseModel>> call(GetVehicleCapacityRequestModel params) async {
    return await repository.getVehicleCapacity(params);
  }
}

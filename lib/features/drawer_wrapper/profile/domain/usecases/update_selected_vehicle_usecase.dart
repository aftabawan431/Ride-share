import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../authentication/auth_wrapper/data/models/update_selected_vehicle_request_model.dart';
import '../../../../authentication/auth_wrapper/data/models/update_selected_vehicle_response_model.dart';
import '../../../../authentication/auth_wrapper/domain/repository/auth_repo.dart';




class UpdateSelectedVehicleUsecase extends UseCase<UpdateSelectedVehicleResponseModel, UpdateSelectedVehicleRequestModel> {
  AuthRepository repository;
  UpdateSelectedVehicleUsecase(this.repository);

  @override
  Future<Either<Failure, UpdateSelectedVehicleResponseModel>> call(UpdateSelectedVehicleRequestModel params) async {
    return await repository.updateSelectedVehicle(params);
  }
}

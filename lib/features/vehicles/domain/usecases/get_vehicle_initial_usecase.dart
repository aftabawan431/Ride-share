import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../data/models/get_vehicle_initials_response.dart';
import '../repository/vechile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class GetVehicleInitialsUsecase extends UseCase<GetVehicleInitialsResponseModel, NoParams> {
  VehicleRepository repository;
  GetVehicleInitialsUsecase(this.repository);

  @override
  // ignore: avoid_renaming_method_parameters
  Future<Either<Failure, GetVehicleInitialsResponseModel>> call(NoParams noParams) async {
    return await repository.getInitials(noParams);
  }
}
import 'package:dartz/dartz.dart';
import '../../data/models/get_schedules_requests_model.dart';
import '../../data/models/get_driver_schedules_response_model.dart';
import '../repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetDriverSchedulesUsecase extends UseCase<GetDriverSchedulesResponseModel, GetSchedulesRequestModel> {
  DrawerWrapperRepository repository;
  GetDriverSchedulesUsecase(this.repository);

  @override
  Future<Either<Failure, GetDriverSchedulesResponseModel>> call(GetSchedulesRequestModel params) async {
    return await repository.getDriverSchedules(params);
  }
}

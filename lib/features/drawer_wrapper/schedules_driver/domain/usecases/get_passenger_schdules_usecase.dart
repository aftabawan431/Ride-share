import 'package:dartz/dartz.dart';
import '../../data/models/get_passenger_schdules_response_model.dart';
import '../../data/models/get_schedules_requests_model.dart';
import '../repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetPassengerSchedulesUsecase extends UseCase<GetPassengerSchdulesResponseModel, GetSchedulesRequestModel> {
  DrawerWrapperRepository repository;
  GetPassengerSchedulesUsecase(this.repository);

  @override
  Future<Either<Failure, GetPassengerSchdulesResponseModel>> call(GetSchedulesRequestModel params) async {
    return await repository.getPassengerSchdules(params);
  }
}

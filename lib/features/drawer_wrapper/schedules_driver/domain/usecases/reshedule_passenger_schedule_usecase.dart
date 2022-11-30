import 'package:dartz/dartz.dart';
import '../../data/models/reschdule_passenger_schedule_request_model.dart';
import '../../data/models/reshedule_response_model.dart';
import '../repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class ReschedulePassengerScheduleUsecase extends UseCase<RescheduleResponseModel, ReschedulePassengerScheduleRequestModel> {
  DrawerWrapperRepository repository;
  ReschedulePassengerScheduleUsecase(this.repository);

  @override
  Future<Either<Failure, RescheduleResponseModel>> call(ReschedulePassengerScheduleRequestModel params) async {
    return await repository.reschedulePassengerSchedule(params);
  }
}

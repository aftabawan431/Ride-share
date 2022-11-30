import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/reshedule_driver_route_request_model.dart';
import '../../data/models/reshedule_response_model.dart';
import '../repository/drawer_wrapper_repository.dart';




class RescheduleDriverRouteUsecase extends UseCase<RescheduleResponseModel, RescheduleDriverRouteRequestModel> {
  DrawerWrapperRepository repository;
  RescheduleDriverRouteUsecase(this.repository);

  @override
  Future<Either<Failure, RescheduleResponseModel>> call(RescheduleDriverRouteRequestModel params) async {
    return await repository.rescheduleDriverRoute(params);
  }
}

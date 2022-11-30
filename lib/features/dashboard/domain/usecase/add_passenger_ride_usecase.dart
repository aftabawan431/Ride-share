import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/model/add_driver_route_request_model.dart';
import '../../data/model/add_ride_request_response_model.dart';
import '../repository/dashboard_repository.dart';




class AddPassengerRideUsecase extends UseCase<AddDriverRideResponseModel, AddPassengerScheduleRequestModel> {
  DashboardRepository repository;
  AddPassengerRideUsecase(this.repository);

  @override
  Future<Either<Failure, AddDriverRideResponseModel>> call(AddPassengerScheduleRequestModel params) async {
    return await repository.addPassengerRequest(params);
  }
}

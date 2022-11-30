import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/model/add_passenger_schedule_request_model.dart';
import '../../data/model/add_ride_request_response_model.dart';
import '../repository/dashboard_repository.dart';




class AddDriverRideUsecase extends UseCase<AddDriverRideResponseModel, AddDriverRouteRequestModel> {
  DashboardRepository repository;
  AddDriverRideUsecase(this.repository);

  @override
  Future<Either<Failure, AddDriverRideResponseModel>> call(AddDriverRouteRequestModel params) async {
    return await repository.addDriverRequest(params);
  }
}

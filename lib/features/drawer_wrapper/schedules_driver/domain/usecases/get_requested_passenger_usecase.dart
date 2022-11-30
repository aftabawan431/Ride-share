import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/get_requested_passenger_request_model.dart';
import '../../data/models/get_requested_passenger_response_model.dart';
import '../repository/drawer_wrapper_repository.dart';




class GetRequestedPassengersUsecase extends UseCase<GetRequestedPassengerResponseModel, GetRequestedPassengersRequestModel> {
  DrawerWrapperRepository repository;
  GetRequestedPassengersUsecase(this.repository);

  @override
  Future<Either<Failure, GetRequestedPassengerResponseModel>> call(GetRequestedPassengersRequestModel params) async {
    return await repository.getRequestedPassengers(params);
  }
}

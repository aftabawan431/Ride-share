import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/model/get_dashboard_history_rides_request_model.dart';
import '../../presentation/widgets/dashboard_ride_history_widget.dart';
import '../repository/dashboard_repository.dart';




class GetDashboardHistoryRidesUsecase extends UseCase<DashboardRideHistoryReponseModel, GetDashboardHistoryRidesRequestModel> {
  DashboardRepository repository;
  GetDashboardHistoryRidesUsecase(this.repository);

  @override
  Future<Either<Failure, DashboardRideHistoryReponseModel>> call(GetDashboardHistoryRidesRequestModel params) async {
    return await repository.getHistoryRides(params);
  }
}

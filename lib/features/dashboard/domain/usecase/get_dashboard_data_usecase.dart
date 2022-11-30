import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../repository/dashboard_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetDashboardDataUsecase extends UseCase<GetDashboardDataResponseModel, NoParams> {
  DashboardRepository repository;
  GetDashboardDataUsecase(this.repository);

  @override
  Future<Either<Failure, GetDashboardDataResponseModel>> call(NoParams params) async {
    return await repository.getDashboardData(NoParams());
  }
}

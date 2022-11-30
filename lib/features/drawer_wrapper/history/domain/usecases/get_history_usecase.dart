import 'package:dartz/dartz.dart';
import '../../model/get_history_request_model.dart';
import '../../model/get_history_response_model.dart';
import '../../../schedules_driver/domain/repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetHistoryUsecase extends UseCase<GetHistoryResponseModel, GetHistoryRequestModel> {
  DrawerWrapperRepository repository;
  GetHistoryUsecase(this.repository);

  @override
  Future<Either<Failure, GetHistoryResponseModel>> call(GetHistoryRequestModel params) async {
    return await repository.getHistory(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/features/drawer_wrapper/history/model/get_driver_history_response_model.dart';
import '../../model/get_history_request_model.dart';
import '../../model/get_history_response_model.dart';
import '../../../schedules_driver/domain/repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetDriverHistoryUsecase extends UseCase<GetDriverHistoryResponseModel, GetHistoryRequestModel> {
  DrawerWrapperRepository repository;
  GetDriverHistoryUsecase(this.repository);

  @override
  Future<Either<Failure, GetDriverHistoryResponseModel>> call(GetHistoryRequestModel params) async {
    return await repository.getDriverHistory(params);
  }
}

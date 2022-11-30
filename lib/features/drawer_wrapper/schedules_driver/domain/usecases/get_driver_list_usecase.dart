import 'package:dartz/dartz.dart';
import '../../data/models/get_drivers_list_request_model.dart';
import '../../data/models/get_drivers_list_response_model.dart';
import '../repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetDriversListUsecase extends UseCase<GetDriversListResponseModel, GetDriversListRequestModel> {
  DrawerWrapperRepository repository;
  GetDriversListUsecase(this.repository);

  @override
  Future<Either<Failure, GetDriversListResponseModel>> call(GetDriversListRequestModel params) async {
    return await repository.getDriversList(params);
  }
}

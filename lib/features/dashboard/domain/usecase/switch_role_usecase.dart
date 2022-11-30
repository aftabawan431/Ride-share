import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../../data/model/switch_role_request_model.dart';
import '../repository/dashboard_repository.dart';




class SwitchRoleUsecase extends UseCase<LoginResponseModel, SwitchRoleRequestModel> {
  DashboardRepository repository;
  SwitchRoleUsecase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(SwitchRoleRequestModel params) async {
    return await repository.switchRole(params);
  }
}

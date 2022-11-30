// ignore_for_file: file_names

import 'package:dartz/dartz.dart';
import '../../../../../core/modals/no_params.dart';
import '../../data/models/get_notifications_response_model.dart';
import '../../../schedules_driver/domain/repository/drawer_wrapper_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetNotificationsUsecase extends UseCase<GetNotificationsResponseModel, NoParams> {
  DrawerWrapperRepository repository;
  GetNotificationsUsecase(this.repository);

  @override
  Future<Either<Failure, GetNotificationsResponseModel>> call(NoParams params) async {
    return await repository.getNotifications(NoParams());
  }
}

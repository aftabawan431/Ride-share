import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/model/add_rating_request_model.dart';
import '../../data/model/add_rating_response_model.dart';
import '../repository/dashboard_repository.dart';




class AddRatingUsecase extends UseCase<AddRatingResponseModel, AddRatingRequestModel> {
  DashboardRepository repository;
  AddRatingUsecase(this.repository);

  @override
  Future<Either<Failure, AddRatingResponseModel>> call(AddRatingRequestModel params) async {
    return await repository.addRating(params);
  }
}

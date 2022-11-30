import 'package:dartz/dartz.dart';
import '../../data/models/otp_verify_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/models/email_verify_request_model.dart';



class VerifyEmailUsecase extends UseCase<OtpVerifyResponseModel, EmailVerifyRequestModel> {
  AuthRepository repository;
  VerifyEmailUsecase(this.repository);

  @override
  Future<Either<Failure, OtpVerifyResponseModel>> call(EmailVerifyRequestModel params) async {
    return await repository.verifyEmail(params);
  }
}
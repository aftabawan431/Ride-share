import 'package:dartz/dartz.dart';
import '../../data/models/resend_otp_request_model.dart';
import '../../data/models/resend_otp_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class ResendOtpUsecase extends UseCase<ResendOtpResponseModel, ResendOtpRequestModel> {
  AuthRepository repository;
  ResendOtpUsecase(this.repository);

  @override
  Future<Either<Failure, ResendOtpResponseModel>> call(ResendOtpRequestModel params) async {
    return await repository.resendOtp(params);
  }
}
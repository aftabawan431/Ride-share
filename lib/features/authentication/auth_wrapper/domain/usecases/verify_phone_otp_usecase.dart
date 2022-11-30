import 'package:dartz/dartz.dart';
import '../../data/models/mobile_verify_request_model.dart';
import '../../data/models/otp_verify_response_model.dart';
import '../repository/auth_repo.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class VerifyPhoneUsecase extends UseCase<OtpVerifyResponseModel, MobileVerifyRequestModel> {
  AuthRepository repository;
  VerifyPhoneUsecase(this.repository);

  @override
  Future<Either<Failure, OtpVerifyResponseModel>> call(MobileVerifyRequestModel params) async {
    return await repository.verifyPhone(params);
  }
}
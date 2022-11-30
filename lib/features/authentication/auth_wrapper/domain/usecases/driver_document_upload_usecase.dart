import 'package:dartz/dartz.dart';
import '../repository/auth_repo.dart';
import '../../../document_verification/models/driver_document_upload_request_model.dart';
import '../../../document_verification/models/driver_document_upload_response_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';



class DriverDocumentUploadUsecase extends UseCase<DriverDocumentUploadResponseModel, DriverDocumentUploadRequestModel> {
  AuthRepository repository;
  DriverDocumentUploadUsecase(this.repository);

  @override
  Future<Either<Failure, DriverDocumentUploadResponseModel>> call(DriverDocumentUploadRequestModel params) async {
    return await repository.driverDocumentUpload(params);
  }
}

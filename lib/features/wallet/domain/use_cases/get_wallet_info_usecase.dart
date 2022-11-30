import 'package:dartz/dartz.dart';
import 'package:flutter_rideshare/features/wallet/data/models/get_wallet_info_request_model.dart';
import 'package:flutter_rideshare/features/wallet/domain/repositories/wallet_repository.dart';
import '../../data/models/get_wallet_info_response_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';




class GetWalletInfoUsecase extends UseCase<GetWalletInfoResponseModel, GetWalletInfoRequestModel> {
  WalletRepository repository;
  GetWalletInfoUsecase(this.repository);

  @override
  Future<Either<Failure, GetWalletInfoResponseModel>> call(GetWalletInfoRequestModel params) async {
    return await repository.getWalletInfo(params);
  }
}

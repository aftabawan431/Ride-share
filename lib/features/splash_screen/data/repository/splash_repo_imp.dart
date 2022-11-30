import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';
import '../data_sources/local_data_source.dart';
import '../../domain/repository/splash_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants/app_messages.dart';
import '../../../../core/utils/network/network_info.dart';

class SplashRepoImp implements SplashRepository{

  final NetworkInfo networkInfo;
  final SplashLocalDatasource datasource;

  SplashRepoImp(this.networkInfo,this.datasource);
  @override
  Future<Either<Failure, User>> getUser(
      NoParams params) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(AppMessages.noInternet));
    }
    try {
      return Right(await datasource.getUser(params));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e));
    }
  }
}
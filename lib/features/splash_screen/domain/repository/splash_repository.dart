import 'package:dartz/dartz.dart';
import '../../../../core/modals/no_params.dart';

import '../../../../core/error/failures.dart';
import '../../../authentication/auth_wrapper/data/models/login_response_modal.dart';

abstract class SplashRepository{
  Future<Either<Failure, User>> getUser(NoParams params);



}
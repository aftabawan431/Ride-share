import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  // here we are using Type because every domain call method will return different Entity
  // Params means if we wanted to add some parameter to that call method so could use Params.
  Future<Either<Failure, Type>> call(Params params);
}


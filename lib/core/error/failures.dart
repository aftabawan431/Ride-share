import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// Network Failure
class SessionFailure extends Failure {
  const SessionFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// No User Found  Failure
class NoUserFoundFailure extends Failure {
  const NoUserFoundFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// No User Found  Failure
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// No User Found  Failure
class UserAlreadyExistsFailure extends Failure {
  const UserAlreadyExistsFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

// No User Found  Failure
class WrongPasscodeFailure extends Failure {
  const WrongPasscodeFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class EmailAlreadyExistsFailure extends Failure {
  const EmailAlreadyExistsFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class EmailAlreadySentFailure extends Failure {
  const EmailAlreadySentFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class NoResultsFoundFailure extends Failure {
  const NoResultsFoundFailure(message) : super(message);
  @override
  List<Object> get props => [message];
}

class ImeiNumberNotFoundFailure extends Failure {
  const ImeiNumberNotFoundFailure(message) : super(message);
  @override
  List<Object?> get props => [message];
}

class SomethingWentWrong extends Failure {
  const SomethingWentWrong(message) : super(message);
  @override
  List<Object?> get props => [message];
}
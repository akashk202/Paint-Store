import 'package:equatable/equatable.dart';

/// Base failure class. All specific failures extend this.
/// Failures are returned via `Either<Failure, T>` from repositories.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Returned when a remote server/Firebase operation fails.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Returned when a local cache operation fails.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Returned when an authentication operation fails.
class AuthFailure extends Failure {
  final String? code;
  const AuthFailure([super.message = 'Authentication failed', this.code]);

  @override
  List<Object?> get props => [message, code];
}

/// Returned when a network connectivity issue is detected.
class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message = 'No internet connection. Please check your network.']);
}

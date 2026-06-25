import 'package:equatable/equatable.dart';
import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';

/// States emitted by the AuthBloc.
/// UI rebuilds based on which state is current.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any auth action.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Authentication operation in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated.
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// An authentication error occurred.
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Password reset email was sent successfully.
class PasswordResetSent extends AuthState {
  const PasswordResetSent();
}

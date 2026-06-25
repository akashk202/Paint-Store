import 'package:equatable/equatable.dart';

/// Events dispatched by the Auth UI to the AuthBloc.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// User tapped Login button.
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// User tapped Register button.
class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String address;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
  });

  @override
  List<Object?> get props => [name, email, phone, password, address];
}

/// User tapped Google Sign In button.
class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

/// User tapped Forgot Password / reset.
class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// User tapped Logout.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Check if user is already authenticated on app start.
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

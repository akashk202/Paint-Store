import 'package:equatable/equatable.dart';

/// States emitted by the UserBloc.
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state before user data is loaded.
class UserInitial extends UserState {
  const UserInitial();
}

/// User data is being loaded.
class UserLoading extends UserState {
  const UserLoading();
}

/// User role loaded/updated.
class UserRoleLoaded extends UserState {
  final String role;

  const UserRoleLoaded(this.role);

  bool get isAdmin => role == 'Admin';
  bool get isManager => role == 'Manager' || isAdmin;
  bool get isCustomer => role == 'Customer';

  @override
  List<Object?> get props => [role];
}

/// User role updated successfully (admin action).
class UserRoleSetSuccess extends UserState {
  const UserRoleSetSuccess();
}

/// An error occurred while loading user data.
class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

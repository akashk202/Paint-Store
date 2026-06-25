import 'package:equatable/equatable.dart';

/// Events dispatched by the User UI to the UserBloc.
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch the role of a specific user.
class FetchUserRole extends UserEvent {
  final String uid;

  const FetchUserRole(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Subscribe to real-time user role updates.
class SubscribeToUserRole extends UserEvent {
  final String uid;

  const SubscribeToUserRole(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// User role updated from Firebase stream.
class UserRoleUpdated extends UserEvent {
  final String role;

  const UserRoleUpdated(this.role);

  @override
  List<Object?> get props => [role];
}

/// Set the role of a user (admin action).
class SetUserRole extends UserEvent {
  final String uid;
  final String role;

  const SetUserRole({required this.uid, required this.role});

  @override
  List<Object?> get props => [uid, role];
}

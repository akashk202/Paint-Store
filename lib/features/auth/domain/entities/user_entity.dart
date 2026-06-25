import 'package:equatable/equatable.dart';

/// Pure domain entity representing an authenticated user.
/// No Firebase-specific logic here — this is framework-agnostic.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final String userType;
  final String status;

  const UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
    this.userType = 'Customer',
    this.status = 'approved',
  });

  /// Whether this user has admin privileges.
  bool get isAdmin => userType == 'Admin';

  /// Whether this user has manager privileges.
  bool get isManager => userType == 'Manager' || isAdmin;

  @override
  List<Object?> get props => [uid, email, name, photoUrl, userType, status];
}

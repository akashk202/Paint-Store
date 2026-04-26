import '../../domain/entities/user_profile_entity.dart';

class UserState {
  final bool loading;
  final UserProfileEntity? profile;
  final String? error;
  final String role; // Quick access to role, default 'Customer'

  const UserState({
    this.loading = false,
    this.profile,
    this.error,
    this.role = 'Customer',
  });

  UserState copyWith({
    bool? loading,
    UserProfileEntity? profile,
    String? error,
    String? role,
  }) {
    return UserState(
      loading: loading ?? this.loading,
      profile: profile ?? this.profile,
      error: error,
      role: role ?? this.role,
    );
  }
}

import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;
  GetUserProfile(this.repository);

  Future<UserProfileEntity> call() => repository.getUserProfile();
}

import '../repositories/user_repository.dart';

class GetUserRole {
  final UserRepository repository;
  GetUserRole(this.repository);

  Future<String> call(String uid) {
    return repository.fetchUserRole(uid);
  }
}

import '../repositories/user_repository.dart';

class UpdateUserRole {
  final UserRepository repository;

  UpdateUserRole(this.repository);

  Future<void> call({required String uid, required String role}) {
    return repository.updateUserRole(uid, role);
  }
}


// implements UseCase

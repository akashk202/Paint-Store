import '../repositories/user_repository.dart';

class UpdateUserPassword {
  final UserRepository repository;
  UpdateUserPassword(this.repository);

  Future<void> call(String currentPassword, String newPassword) {
    return repository.updateUserPassword(currentPassword, newPassword);
  }
}

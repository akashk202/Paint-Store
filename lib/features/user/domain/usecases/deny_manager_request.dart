import '../repositories/user_repository.dart';

class DenyManagerRequest {
  final UserRepository repository;

  DenyManagerRequest(this.repository);

  Future<void> call(String uid) {
    return repository.denyManagerRequest(uid);
  }
}


// implements UseCase

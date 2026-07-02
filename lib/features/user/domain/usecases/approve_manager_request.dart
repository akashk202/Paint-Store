import '../repositories/user_repository.dart';

class ApproveManagerRequest {
  final UserRepository repository;

  ApproveManagerRequest(this.repository);

  Future<void> call(String uid) {
    return repository.approveManagerRequest(uid);
  }
}


// implements UseCase

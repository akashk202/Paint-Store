import '../repositories/user_repository.dart';

class FetchPendingManagerRequests {
  final UserRepository repository;

  FetchPendingManagerRequests(this.repository);

  Future<List<Map<String, dynamic>>> call() {
    return repository.fetchPendingManagerRequests();
  }
}


// implements UseCase

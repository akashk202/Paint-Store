import '../repositories/user_repository.dart';

class FetchAllUsersStream {
  final UserRepository repository;

  FetchAllUsersStream(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.fetchAllUsersStream();
  }
}


// implements UseCase

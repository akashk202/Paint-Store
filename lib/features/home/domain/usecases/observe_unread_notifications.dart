import '../repositories/home_repository.dart';

class ObserveUnreadNotifications {
  final HomeRepository repository;

  ObserveUnreadNotifications(this.repository);

  Stream<int> call(String uid) {
    return repository.unreadCountStream(uid);
  }
}


// implements UseCase

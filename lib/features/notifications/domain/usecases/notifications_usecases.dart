import '../repositories/notifications_repository.dart';

class WatchDismissedNotifications {
  final NotificationsRepository repository;
  WatchDismissedNotifications(this.repository);

  Stream<Map<String, dynamic>> call(String uid) {
    return repository.watchDismissedNotifications(uid);
  }
}

class WatchPersonalNotifications {
  final NotificationsRepository repository;
  WatchPersonalNotifications(this.repository);

  Stream<Map<String, Map<String, dynamic>>> call(String uid) {
    return repository.watchPersonalNotifications(uid);
  }
}

class WatchGlobalAdminsNotifications {
  final NotificationsRepository repository;
  WatchGlobalAdminsNotifications(this.repository);

  Stream<Map<String, Map<String, dynamic>>> call() {
    return repository.watchGlobalAdminsNotifications();
  }
}

class WatchGlobalManagersNotifications {
  final NotificationsRepository repository;
  WatchGlobalManagersNotifications(this.repository);

  Stream<Map<String, Map<String, dynamic>>> call() {
    return repository.watchGlobalManagersNotifications();
  }
}

class MarkAllNotificationsRead {
  final NotificationsRepository repository;
  MarkAllNotificationsRead(this.repository);

  Future<void> call(String uid) {
    return repository.markAllRead(uid);
  }
}

class ClearAllNotifications {
  final NotificationsRepository repository;
  ClearAllNotifications(this.repository);

  Future<void> call(String uid) {
    return repository.clearAll(uid);
  }
}

class DismissGlobalNotification {
  final NotificationsRepository repository;
  DismissGlobalNotification(this.repository);

  Future<void> call(String uid, String signature) {
    return repository.dismissGlobal(uid, signature);
  }
}

class DeletePersonalNotification {
  final NotificationsRepository repository;
  DeletePersonalNotification(this.repository);

  Future<void> call(String uid, String key) {
    return repository.deletePersonal(uid, key);
  }
}


// implements UseCase

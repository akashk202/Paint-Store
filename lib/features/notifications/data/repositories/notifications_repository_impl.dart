import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Map<String, dynamic>> watchDismissedNotifications(String uid) {
    return remoteDataSource.watchDismissedNotifications(uid);
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchPersonalNotifications(String uid) {
    return remoteDataSource.watchPersonalNotifications(uid);
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchGlobalAdminsNotifications() {
    return remoteDataSource.watchGlobalAdminsNotifications();
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchGlobalManagersNotifications() {
    return remoteDataSource.watchGlobalManagersNotifications();
  }

  @override
  Future<void> markAllRead(String uid) {
    return remoteDataSource.markAllRead(uid);
  }

  @override
  Future<void> clearAll(String uid) {
    return remoteDataSource.clearAll(uid);
  }

  @override
  Future<void> dismissGlobal(String uid, String signature) {
    return remoteDataSource.dismissGlobal(uid, signature);
  }

  @override
  Future<void> deletePersonal(String uid, String key) {
    return remoteDataSource.deletePersonal(uid, key);
  }
}

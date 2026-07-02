abstract class NotificationsRepository {
  Stream<Map<String, dynamic>> watchDismissedNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchPersonalNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchGlobalAdminsNotifications();
  Stream<Map<String, Map<String, dynamic>>> watchGlobalManagersNotifications();

  Future<void> markAllRead(String uid);
  Future<void> clearAll(String uid);
  Future<void> dismissGlobal(String uid, String signature);
  Future<void> deletePersonal(String uid, String key);
}


// Either<Failure, T>

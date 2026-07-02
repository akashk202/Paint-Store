import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';

abstract class NotificationsRepository {
  Stream<Map<String, dynamic>> watchDismissedNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchPersonalNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchGlobalAdminsNotifications();
  Stream<Map<String, Map<String, dynamic>>> watchGlobalManagersNotifications();

  Future<Either<Failure, void>> markAllRead(String uid);
  Future<Either<Failure, void>> clearAll(String uid);
  Future<Either<Failure, void>> dismissGlobal(String uid, String signature);
  Future<Either<Failure, void>> deletePersonal(String uid, String key);
}

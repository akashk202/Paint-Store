import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
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
  Future<Either<Failure, void>> markAllRead(String uid) async {
    try {
      await remoteDataSource.markAllRead(uid);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAll(String uid) async {
    try {
      await remoteDataSource.clearAll(uid);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> dismissGlobal(String uid, String signature) async {
    try {
      await remoteDataSource.dismissGlobal(uid, signature);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePersonal(String uid, String key) async {
    try {
      await remoteDataSource.deletePersonal(uid, key);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

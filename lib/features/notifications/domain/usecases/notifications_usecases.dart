import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/notifications_repository.dart';

class WatchDismissedNotifications implements StreamUseCase<Map<String, dynamic>, String> {
  final NotificationsRepository repository;
  WatchDismissedNotifications(this.repository);

  @override
  Stream<Map<String, dynamic>> call(String params) {
    return repository.watchDismissedNotifications(params);
  }
}

class WatchPersonalNotifications implements StreamUseCase<Map<String, Map<String, dynamic>>, String> {
  final NotificationsRepository repository;
  WatchPersonalNotifications(this.repository);

  @override
  Stream<Map<String, Map<String, dynamic>>> call(String params) {
    return repository.watchPersonalNotifications(params);
  }
}

class WatchGlobalAdminsNotifications implements StreamUseCase<Map<String, Map<String, dynamic>>, NoParams> {
  final NotificationsRepository repository;
  WatchGlobalAdminsNotifications(this.repository);

  @override
  Stream<Map<String, Map<String, dynamic>>> call(NoParams params) {
    return repository.watchGlobalAdminsNotifications();
  }
}

class WatchGlobalManagersNotifications implements StreamUseCase<Map<String, Map<String, dynamic>>, NoParams> {
  final NotificationsRepository repository;
  WatchGlobalManagersNotifications(this.repository);

  @override
  Stream<Map<String, Map<String, dynamic>>> call(NoParams params) {
    return repository.watchGlobalManagersNotifications();
  }
}

class MarkAllNotificationsRead implements UseCase<void, String> {
  final NotificationsRepository repository;
  MarkAllNotificationsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.markAllRead(params);
  }
}

class ClearAllNotifications implements UseCase<void, String> {
  final NotificationsRepository repository;
  ClearAllNotifications(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.clearAll(params);
  }
}

class DismissGlobalNotification implements UseCase<void, DismissGlobalParams> {
  final NotificationsRepository repository;
  DismissGlobalNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(DismissGlobalParams params) {
    return repository.dismissGlobal(params.uid, params.signature);
  }
}

class DismissGlobalParams extends Equatable {
  final String uid;
  final String signature;

  const DismissGlobalParams({required this.uid, required this.signature});

  @override
  List<Object?> get props => [uid, signature];
}

class DeletePersonalNotification implements UseCase<void, DeletePersonalParams> {
  final NotificationsRepository repository;
  DeletePersonalNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePersonalParams params) {
    return repository.deletePersonal(params.uid, params.key);
  }
}

class DeletePersonalParams extends Equatable {
  final String uid;
  final String key;

  const DeletePersonalParams({required this.uid, required this.key});

  @override
  List<Object?> get props => [uid, key];
}

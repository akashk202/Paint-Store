import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/notifications_usecases.dart';
import '../../../user/presentation/providers/user_providers.dart';
import 'notifications_state.dart';
import 'notifications_notifier.dart';

final _notificationsRemoteDataSourceProvider = Provider<NotificationsRemoteDataSource>((ref) {
  return NotificationsRemoteDataSourceImpl(FirebaseDatabase.instance.ref());
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(ref.read(_notificationsRemoteDataSourceProvider));
});

final watchDismissedNotificationsProvider = Provider<WatchDismissedNotifications>((ref) {
  return WatchDismissedNotifications(ref.read(notificationsRepositoryProvider));
});

final watchPersonalNotificationsProvider = Provider<WatchPersonalNotifications>((ref) {
  return WatchPersonalNotifications(ref.read(notificationsRepositoryProvider));
});

final watchGlobalAdminsNotificationsProvider = Provider<WatchGlobalAdminsNotifications>((ref) {
  return WatchGlobalAdminsNotifications(ref.read(notificationsRepositoryProvider));
});

final watchGlobalManagersNotificationsProvider = Provider<WatchGlobalManagersNotifications>((ref) {
  return WatchGlobalManagersNotifications(ref.read(notificationsRepositoryProvider));
});

final markAllNotificationsReadProvider = Provider<MarkAllNotificationsRead>((ref) {
  return MarkAllNotificationsRead(ref.read(notificationsRepositoryProvider));
});

final clearAllNotificationsProvider = Provider<ClearAllNotifications>((ref) {
  return ClearAllNotifications(ref.read(notificationsRepositoryProvider));
});

final dismissGlobalNotificationProvider = Provider<DismissGlobalNotification>((ref) {
  return DismissGlobalNotification(ref.read(notificationsRepositoryProvider));
});

final deletePersonalNotificationProvider = Provider<DeletePersonalNotification>((ref) {
  return DeletePersonalNotification(ref.read(notificationsRepositoryProvider));
});

final notificationsNotifierProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(
    watchDismissed: ref.read(watchDismissedNotificationsProvider),
    watchPersonal: ref.read(watchPersonalNotificationsProvider),
    watchGlobalAdmins: ref.read(watchGlobalAdminsNotificationsProvider),
    watchGlobalManagers: ref.read(watchGlobalManagersNotificationsProvider),
    markAllRead: ref.read(markAllNotificationsReadProvider),
    clearAll: ref.read(clearAllNotificationsProvider),
    dismissGlobal: ref.read(dismissGlobalNotificationProvider),
    deletePersonal: ref.read(deletePersonalNotificationProvider),
    getUserRole: ref.read(getUserRoleUseCaseProvider),
  );
});

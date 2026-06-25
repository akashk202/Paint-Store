import 'package:equatable/equatable.dart';

/// States emitted by the NotificationsBloc.
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before notifications are loaded.
class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

/// Notifications are being loaded.
class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

/// Notifications loaded successfully.
class NotificationsLoaded extends NotificationsState {
  final Map<String, Map<String, dynamic>> personalNotifications;
  final Map<String, Map<String, dynamic>> globalManagerNotifications;
  final Map<String, Map<String, dynamic>> globalAdminNotifications;
  final Map<String, dynamic> dismissedMap;
  final String uid;
  final String userRole;

  const NotificationsLoaded({
    required this.personalNotifications,
    required this.globalManagerNotifications,
    required this.globalAdminNotifications,
    required this.dismissedMap,
    required this.uid,
    required this.userRole,
  });

  int get unreadCount {
    int count = 0;
    for (final n in personalNotifications.values) {
      if (n['isRead'] != true) count++;
    }
    return count;
  }

  NotificationsLoaded copyWith({
    Map<String, Map<String, dynamic>>? personalNotifications,
    Map<String, Map<String, dynamic>>? globalManagerNotifications,
    Map<String, Map<String, dynamic>>? globalAdminNotifications,
    Map<String, dynamic>? dismissedMap,
    String? uid,
    String? userRole,
  }) {
    return NotificationsLoaded(
      personalNotifications:
          personalNotifications ?? this.personalNotifications,
      globalManagerNotifications:
          globalManagerNotifications ?? this.globalManagerNotifications,
      globalAdminNotifications:
          globalAdminNotifications ?? this.globalAdminNotifications,
      dismissedMap: dismissedMap ?? this.dismissedMap,
      uid: uid ?? this.uid,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object?> get props => [
        personalNotifications,
        globalManagerNotifications,
        globalAdminNotifications,
        dismissedMap,
        uid,
        userRole,
      ];
}

/// An error occurred while loading notifications.
class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

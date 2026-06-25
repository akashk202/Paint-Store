import 'package:equatable/equatable.dart';

/// Events dispatched by the Notifications UI to the NotificationsBloc.
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribe to all notification streams (personal + global).
class SubscribeToNotifications extends NotificationsEvent {
  final String uid;
  final String userRole;

  const SubscribeToNotifications({required this.uid, required this.userRole});

  @override
  List<Object?> get props => [uid, userRole];
}

/// Personal notifications updated from Firebase stream.
class PersonalNotificationsUpdated extends NotificationsEvent {
  final Map<String, Map<String, dynamic>> notifications;

  const PersonalNotificationsUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Global manager notifications updated from Firebase stream.
class GlobalManagerNotificationsUpdated extends NotificationsEvent {
  final Map<String, Map<String, dynamic>> notifications;

  const GlobalManagerNotificationsUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Global admin notifications updated from Firebase stream.
class GlobalAdminNotificationsUpdated extends NotificationsEvent {
  final Map<String, Map<String, dynamic>> notifications;

  const GlobalAdminNotificationsUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Dismissed notifications map updated.
class DismissedMapUpdated extends NotificationsEvent {
  final Map<String, dynamic> dismissed;

  const DismissedMapUpdated(this.dismissed);

  @override
  List<Object?> get props => [dismissed];
}

/// Mark all personal notifications as read.
class MarkAllRead extends NotificationsEvent {
  const MarkAllRead();
}

/// Clear all personal notifications.
class ClearAllNotifications extends NotificationsEvent {
  const ClearAllNotifications();
}

/// Dismiss a global notification.
class DismissGlobalNotification extends NotificationsEvent {
  final String signature;

  const DismissGlobalNotification(this.signature);

  @override
  List<Object?> get props => [signature];
}

/// Delete a personal notification.
class DeletePersonalNotification extends NotificationsEvent {
  final String key;

  const DeletePersonalNotification(this.key);

  @override
  List<Object?> get props => [key];
}

import '../../domain/entities/notification_entity.dart';

class NotificationsState {
  final bool loading;
  final List<NotificationEntity> entries;
  final Object? error;

  const NotificationsState({
    this.loading = false,
    this.entries = const [],
    this.error,
  });

  NotificationsState copyWith({
    bool? loading,
    List<NotificationEntity>? entries,
    Object? error,
  }) {
    return NotificationsState(
      loading: loading ?? this.loading,
      entries: entries ?? this.entries,
      error: error,
    );
  }
}

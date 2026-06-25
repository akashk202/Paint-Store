import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/notifications_repository.dart';
import 'package:c_h_p/data/repositories/user_repository.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

export 'notifications_event.dart';
export 'notifications_state.dart';

/// NotificationsBloc: manages notification streams and actions.
/// Subscribes to personal, global manager, and global admin streams.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository repository;
  final UserRepository userRepository;
  StreamSubscription? _personalSub;
  StreamSubscription? _managerSub;
  StreamSubscription? _adminSub;
  StreamSubscription? _dismissedSub;

  NotificationsBloc({
    required this.repository,
    required this.userRepository,
  }) : super(const NotificationsInitial()) {
    on<SubscribeToNotifications>(_onSubscribe);
    on<PersonalNotificationsUpdated>(_onPersonalUpdated);
    on<GlobalManagerNotificationsUpdated>(_onManagerUpdated);
    on<GlobalAdminNotificationsUpdated>(_onAdminUpdated);
    on<DismissedMapUpdated>(_onDismissedUpdated);
    on<MarkAllRead>(_onMarkAllRead);
    on<ClearAllNotifications>(_onClearAll);
    on<DismissGlobalNotification>(_onDismissGlobal);
    on<DeletePersonalNotification>(_onDeletePersonal);
  }

  Future<void> _onSubscribe(
    SubscribeToNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());

    // Cancel existing subscriptions
    await _personalSub?.cancel();
    await _managerSub?.cancel();
    await _adminSub?.cancel();
    await _dismissedSub?.cancel();

    // Emit initial loaded state
    emit(NotificationsLoaded(
      personalNotifications: const {},
      globalManagerNotifications: const {},
      globalAdminNotifications: const {},
      dismissedMap: const {},
      uid: event.uid,
      userRole: event.userRole,
    ));

    // Subscribe to personal notifications
    _personalSub = repository.personalStream(event.uid).listen(
      (data) => add(PersonalNotificationsUpdated(data)),
      onError: (_) {},
    );

    // Subscribe to dismissed map
    _dismissedSub = repository.dismissedMapStream(event.uid).listen(
      (data) => add(DismissedMapUpdated(data)),
      onError: (_) {},
    );

    // Subscribe to role-based global streams
    if (event.userRole == 'Manager' || event.userRole == 'Admin') {
      _managerSub = repository.globalManagersStream().listen(
        (data) => add(GlobalManagerNotificationsUpdated(data)),
        onError: (_) {},
      );
    }

    if (event.userRole == 'Admin') {
      _adminSub = repository.globalAdminsStream().listen(
        (data) => add(GlobalAdminNotificationsUpdated(data)),
        onError: (_) {},
      );
    }
  }

  void _onPersonalUpdated(
    PersonalNotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(personalNotifications: event.notifications));
    }
  }

  void _onManagerUpdated(
    GlobalManagerNotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(globalManagerNotifications: event.notifications));
    }
  }

  void _onAdminUpdated(
    GlobalAdminNotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(globalAdminNotifications: event.notifications));
    }
  }

  void _onDismissedUpdated(
    DismissedMapUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(dismissedMap: event.dismissed));
    }
  }

  Future<void> _onMarkAllRead(
    MarkAllRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is NotificationsLoaded) {
      try {
        await repository.markAllRead(current.uid);
      } catch (_) {}
    }
  }

  Future<void> _onClearAll(
    ClearAllNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is NotificationsLoaded) {
      try {
        await repository.clearAll(current.uid);
      } catch (_) {}
    }
  }

  Future<void> _onDismissGlobal(
    DismissGlobalNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is NotificationsLoaded) {
      try {
        await repository.dismissGlobal(current.uid, event.signature);
      } catch (_) {}
    }
  }

  Future<void> _onDeletePersonal(
    DeletePersonalNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is NotificationsLoaded) {
      try {
        await repository.deletePersonal(current.uid, event.key);
      } catch (_) {}
    }
  }

  @override
  Future<void> close() {
    _personalSub?.cancel();
    _managerSub?.cancel();
    _adminSub?.cancel();
    _dismissedSub?.cancel();
    return super.close();
  }
}

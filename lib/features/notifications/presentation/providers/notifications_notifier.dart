import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/notifications_usecases.dart';
import '../../../user/domain/usecases/get_user_role.dart';
import 'notifications_state.dart';

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final WatchDismissedNotifications _watchDismissed;
  final WatchPersonalNotifications _watchPersonal;
  final WatchGlobalAdminsNotifications _watchGlobalAdmins;
  final WatchGlobalManagersNotifications _watchGlobalManagers;
  final MarkAllNotificationsRead _markAllRead;
  final ClearAllNotifications _clearAll;
  final DismissGlobalNotification _dismissGlobal;
  final DeletePersonalNotification _deletePersonal;
  final GetUserRole _getUserRole;

  StreamSubscription<Map<String, Map<String, dynamic>>>? _personalSub;
  StreamSubscription<Map<String, Map<String, dynamic>>>? _globalSub;
  StreamSubscription<Map<String, dynamic>>? _dismissedSub;

  String? _role;
  Map<String, Map<String, dynamic>> _personal = {};
  Map<String, Map<String, dynamic>> _global = {};
  Set<String> _dismissed = {};

  NotificationsNotifier({
    required WatchDismissedNotifications watchDismissed,
    required WatchPersonalNotifications watchPersonal,
    required WatchGlobalAdminsNotifications watchGlobalAdmins,
    required WatchGlobalManagersNotifications watchGlobalManagers,
    required MarkAllNotificationsRead markAllRead,
    required ClearAllNotifications clearAll,
    required DismissGlobalNotification dismissGlobal,
    required DeletePersonalNotification deletePersonal,
    required GetUserRole getUserRole,
  })  : _watchDismissed = watchDismissed,
        _watchPersonal = watchPersonal,
        _watchGlobalAdmins = watchGlobalAdmins,
        _watchGlobalManagers = watchGlobalManagers,
        _markAllRead = markAllRead,
        _clearAll = clearAll,
        _dismissGlobal = dismissGlobal,
        _deletePersonal = deletePersonal,
        _getUserRole = getUserRole,
        super(const NotificationsState());

  Future<void> start(String uid) async {
    state = state.copyWith(loading: true, error: null);
    final roleResult = await _getUserRole(uid);
    roleResult.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (role) {
        _role = role;
        _listen(uid);
        state = state.copyWith(loading: false);
      },
    );
  }

  void _listen(String uid) {
    _personalSub?.cancel();
    _globalSub?.cancel();
    _dismissedSub?.cancel();

    _dismissedSub = _watchDismissed(uid).listen((map) {
      _dismissed = map.keys.map((k) => k.toString()).toSet();
      _recompute();
    });

    _personalSub = _watchPersonal(uid).listen((map) {
      _personal = map;
      _recompute();
    });

    final isAdmin = _role == 'Admin';
    final isManager = _role == 'Manager';

    if (isAdmin || isManager) {
      final stream = isAdmin ? _watchGlobalAdmins(const NoParams()) : _watchGlobalManagers(const NoParams());
      _globalSub = stream.listen((map) {
        _global = map;
        _recompute();
      });
    } else {
      _global = {};
      _recompute();
    }
  }

  void _recompute() {
    final List<NotificationEntity> out = [];
    final Set<String> seen = {};

    void addAll(String src, Map<String, Map<String, dynamic>> map) {
      map.forEach((k, v) {
        final ts = (v['timestamp'] ?? 0).toString();
        final msg = (v['message'] ?? '').toString();
        final type = (v['type'] ?? '').toString();
        final sig = '$type|$ts|$msg';
        
        if (src == 'g') {
          if (_dismissed.contains(sig)) return;
          if (seen.add(sig)) {
            out.add(NotificationEntity(key: sig, data: v, src: src));
          }
        } else {
          if (seen.add('p|$k')) {
            out.add(NotificationEntity(key: k, data: v, src: src));
          }
        }
      });
    }

    addAll('p', _personal);
    addAll('g', _global);

    out.sort((a, b) {
      return b.timestamp.compareTo(a.timestamp);
    });

    state = state.copyWith(entries: out);
  }

  Future<void> markAllRead(String uid) async {
    final result = await _markAllRead(uid);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {},
    );
  }

  Future<void> clearAll(String uid) async {
    final result = await _clearAll(uid);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {},
    );
  }

  Future<void> dismissGlobal(String uid, String signature) async {
    final result = await _dismissGlobal(DismissGlobalParams(uid: uid, signature: signature));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {},
    );
  }

  Future<void> deletePersonal(String uid, String key) async {
    final result = await _deletePersonal(DeletePersonalParams(uid: uid, key: key));
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {},
    );
  }

  @override
  void dispose() {
    _personalSub?.cancel();
    _globalSub?.cancel();
    _dismissedSub?.cancel();
    super.dispose();
  }
}

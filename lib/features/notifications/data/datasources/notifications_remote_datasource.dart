import 'package:firebase_database/firebase_database.dart';

abstract class NotificationsRemoteDataSource {
  Stream<Map<String, dynamic>> watchDismissedNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchPersonalNotifications(String uid);
  Stream<Map<String, Map<String, dynamic>>> watchGlobalAdminsNotifications();
  Stream<Map<String, Map<String, dynamic>>> watchGlobalManagersNotifications();

  Future<void> markAllRead(String uid);
  Future<void> clearAll(String uid);
  Future<void> dismissGlobal(String uid, String signature);
  Future<void> deletePersonal(String uid, String key);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DatabaseReference dbRef;

  NotificationsRemoteDataSourceImpl(this.dbRef);

  @override
  Stream<Map<String, dynamic>> watchDismissedNotifications(String uid) {
    return dbRef.child('users/$uid/dismissedNotifications').onValue.map((e) {
      if (!e.snapshot.exists || e.snapshot.value == null) {
        return <String, dynamic>{};
      }
      try {
        return Map<String, dynamic>.from(e.snapshot.value as Map);
      } catch (_) {
        return <String, dynamic>{};
      }
    });
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchPersonalNotifications(String uid) {
    return dbRef
        .child('users/$uid/notifications')
        .orderByChild('timestamp')
        .limitToLast(100)
        .onValue
        .map((e) {
      if (!e.snapshot.exists || e.snapshot.value == null) {
        return <String, Map<String, dynamic>>{};
      }
      final map = Map<String, dynamic>.from(e.snapshot.value as Map);
      final out = <String, Map<String, dynamic>>{};
      map.forEach((k, v) {
        try {
          out[k] = Map<String, dynamic>.from(v);
        } catch (_) {}
      });
      return out;
    });
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchGlobalAdminsNotifications() {
    return dbRef
        .child('notifications/globalForAdmins')
        .orderByChild('timestamp')
        .limitToLast(100)
        .onValue
        .map((e) {
      if (!e.snapshot.exists || e.snapshot.value == null) {
        return <String, Map<String, dynamic>>{};
      }
      final map = Map<String, dynamic>.from(e.snapshot.value as Map);
      final out = <String, Map<String, dynamic>>{};
      map.forEach((k, v) {
        try {
          out[k] = Map<String, dynamic>.from(v);
        } catch (_) {}
      });
      return out;
    });
  }

  @override
  Stream<Map<String, Map<String, dynamic>>> watchGlobalManagersNotifications() {
    return dbRef
        .child('notifications/globalForManagers')
        .orderByChild('timestamp')
        .limitToLast(100)
        .onValue
        .map((e) {
      if (!e.snapshot.exists || e.snapshot.value == null) {
        return <String, Map<String, dynamic>>{};
      }
      final map = Map<String, dynamic>.from(e.snapshot.value as Map);
      final out = <String, Map<String, dynamic>>{};
      map.forEach((k, v) {
        try {
          out[k] = Map<String, dynamic>.from(v);
        } catch (_) {}
      });
      return out;
    });
  }

  @override
  Future<void> markAllRead(String uid) async {
    final ref = dbRef.child('users/$uid/notifications');
    final snap = await ref.get();
    if (!snap.exists || snap.value == null) return;
    
    final updates = <String, dynamic>{};
    for (final c in snap.children) {
      final v = c.value;
      bool alreadyTrue = false;
      if (v is Map) {
        final isReadVal = v['isRead'];
        alreadyTrue = isReadVal == true;
      }
      if (!alreadyTrue) {
        updates['${c.key}/isRead'] = true;
      }
    }
    if (updates.isNotEmpty) await ref.update(updates);
  }

  @override
  Future<void> clearAll(String uid) async {
    await dbRef.child('users/$uid/notifications').remove();
  }

  @override
  Future<void> dismissGlobal(String uid, String signature) async {
    await dbRef.child('users/$uid/dismissedNotifications/$signature').set(true);
  }

  @override
  Future<void> deletePersonal(String uid, String key) async {
    await dbRef.child('users/$uid/notifications/$key').remove();
  }
}

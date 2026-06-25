import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/report_entity.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitIssue(String issueText);
  Stream<List<ReportEntity>> watchReports();
  Future<void> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final DatabaseReference dbRef;
  final FirebaseAuth auth;

  ReportRemoteDataSourceImpl({required this.dbRef, required this.auth});

  @override
  Future<void> submitIssue(String issueText) async {
    final u = auth.currentUser;
    if (u == null) throw Exception('Not authenticated');
    await dbRef.child('reports').push().set({
      'userId': u.uid,
      'name': u.displayName ?? 'Anonymous',
      'email': u.email ?? 'No Email',
      'issue': issueText,
      'timestamp': ServerValue.timestamp,
      'status': 'Pending',
    });
  }

  @override
  Stream<List<ReportEntity>> watchReports() {
    return dbRef.child('reports').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <ReportEntity>[];
      }
      final raw = Map<String, dynamic>.from(event.snapshot.value as Map);
      final list = raw.entries.map((e) {
        final v = Map<String, dynamic>.from(e.value as Map);
        return ReportEntity.fromMap(e.key, v);
      }).toList();
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }

  @override
  Future<void> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  }) async {
    await dbRef.child('reports/$reportKey').update({'status': 'Resolved'});
    final shortIssue =
        issueText.length > 30 ? '${issueText.substring(0, 30)}...' : issueText;
    await dbRef.child('users/$userId/notifications').push().set({
      'message':
          'Your report about "$shortIssue" has been received and is now being processed.',
      'timestamp': ServerValue.timestamp,
      'isRead': false,
    });
  }
}

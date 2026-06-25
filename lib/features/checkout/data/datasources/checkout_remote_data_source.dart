import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Contract for the checkout remote data source.
abstract class CheckoutRemoteDataSource {
  Future<Map<String, dynamic>?> fetchUserProfile();
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  });
  Future<List<String>> fetchCartItemNames();
}

/// Implementation wrapping Firebase Realtime Database.
class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;

  CheckoutRemoteDataSourceImpl({
    FirebaseAuth? auth,
    DatabaseReference? dbRef,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _dbRef = dbRef ?? FirebaseDatabase.instance.ref();

  User? get _user => _auth.currentUser;

  @override
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final u = _user;
    if (u == null) return null;
    final snap = await _dbRef.child('users/${u.uid}/profile').get();
    if (!snap.exists || snap.value == null) return null;
    return Map<String, dynamic>.from(snap.value as Map);
  }

  @override
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  }) async {
    final u = _user;
    if (u == null) return;
    final payload = <String, dynamic>{
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'updatedAt': ServerValue.timestamp,
    };
    if (lat != null && lng != null) {
      payload['location'] = {'lat': lat, 'lng': lng};
    }
    await _dbRef.child('users/${u.uid}/profile').update(payload);
  }

  @override
  Future<List<String>> fetchCartItemNames() async {
    final u = _user;
    if (u == null) return <String>[];
    final snap = await _dbRef.child('users/${u.uid}/cart').get();
    if (!snap.exists || snap.value == null) return <String>[];
    final cartMap = Map<String, dynamic>.from(snap.value as Map);
    final List<String> names = [];
    for (final e in cartMap.entries) {
      final v = Map<String, dynamic>.from(e.value);
      final n = (v['name'] ?? '').toString();
      if (n.isNotEmpty) names.add(n);
    }
    return names;
  }
}

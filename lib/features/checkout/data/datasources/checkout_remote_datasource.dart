import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class CheckoutRemoteDataSource {
  Map<String, String> fetchSignedInUserDetails();

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

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final FirebaseDatabase db;
  final FirebaseAuth auth;

  CheckoutRemoteDataSourceImpl({
    required this.db,
    required this.auth,
  });

  DatabaseReference get _root => db.ref();
  User? get _user => auth.currentUser;

  @override
  Map<String, String> fetchSignedInUserDetails() {
    final u = _user;
    if (u == null) {
      return const <String, String>{};
    }

    return <String, String>{
      'name': u.displayName?.trim() ?? '',
      'email': u.email?.trim() ?? '',
      'phone': u.phoneNumber?.trim() ?? '',
    };
  }

  @override
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final u = _user;
    if (u == null) return null;
    
    final snap = await _root.child('users/${u.uid}/profile').get();
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

    await _root.child('users/${u.uid}/profile').update(payload);
  }

  @override
  Future<List<String>> fetchCartItemNames() async {
    final u = _user;
    if (u == null) return <String>[];

    final snap = await _root.child('users/${u.uid}/cart').get();
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

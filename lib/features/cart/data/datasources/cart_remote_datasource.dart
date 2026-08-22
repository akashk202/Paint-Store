import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class CartRemoteDataSource {
  Stream<Map<String, Map<String, dynamic>>> cartStream();

  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  });

  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  });

  Future<void> removeItem(String productKey);

  Future<void> clearCart();

  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  });

  /// Fetch full product details for a list of product keys (for cart enrichment).
  Future<Map<String, Map<String, dynamic>?>> fetchProductDetails(
      List<String> productKeys);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseDatabase db;
  final FirebaseAuth auth;

  CartRemoteDataSourceImpl({
    required this.db,
    required this.auth,
  });

  DatabaseReference get _db => db.ref();
  User? get _user => auth.currentUser;

  @override
  Stream<Map<String, Map<String, dynamic>>> cartStream() {
    final u = _user;
    if (u == null) return const Stream.empty();

    return _db.child('users/${u.uid}/cart').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <String, Map<String, dynamic>>{};
      }

      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final out = <String, Map<String, dynamic>>{};

      map.forEach((k, v) {
        try {
          out[k] = Map<String, dynamic>.from(v as Map);
        } catch (_) {}
      });

      return out;
    });
  }

  @override
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  }) async {
    final u = _user;
    if (u == null) return;

    if (quantity <= 0) {
      await _db.child('users/${u.uid}/cart/$productKey').remove();
    } else {
      await _db
          .child('users/${u.uid}/cart/$productKey/quantity')
          .set(quantity);
    }
  }

  @override
  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  }) async {
    final u = _user;
    if (u == null) return;

    final idx = productKey.indexOf('_');
    final cleanKey = idx != -1 ? productKey.substring(0, idx) : productKey;

    final oldRef = _db.child('users/${u.uid}/cart/$productKey');
    final oldSnap = await oldRef.get();
    if (!oldSnap.exists || oldSnap.value is! Map) return;

    final oldMap = Map<String, dynamic>.from(oldSnap.value as Map);
    final name = oldMap['name'] ?? '';
    final imageUrl = oldMap['mainImageUrl'] ?? '';
    final oldQty = (oldMap['quantity'] ?? 1) is int
        ? oldMap['quantity'] as int
        : int.tryParse('${oldMap['quantity']}') ?? 1;

    await oldRef.remove();

    final sanitizedSize = size.replaceAll(RegExp(r'[.#$/\[\]]'), '_');
    final newCompositeKey = '${cleanKey}_$sanitizedSize';
    final newRef = _db.child('users/${u.uid}/cart/$newCompositeKey');

    final newSnap = await newRef.get();
    int targetQty = oldQty;
    if (newSnap.exists && newSnap.value is Map) {
      final newMap = Map<String, dynamic>.from(newSnap.value as Map);
      final int newQty = (newMap['quantity'] ?? 0) is int
          ? newMap['quantity'] as int
          : int.tryParse('${newMap['quantity']}') ?? 0;
      targetQty += newQty;
    }

    await newRef.set({
      'name': name,
      'mainImageUrl': imageUrl,
      'selectedSize': size,
      'selectedPrice': price,
      'quantity': targetQty,
    });
  }

  @override
  Future<void> removeItem(String productKey) async {
    final u = _user;
    if (u == null) return;

    await _db.child('users/${u.uid}/cart/$productKey').remove();
  }

  @override
  Future<void> clearCart() async {
    final u = _user;
    if (u == null) return;

    await _db.child('users/${u.uid}/cart').remove();
  }

  @override
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  }) async {
    final u = _user;
    if (u == null) return;

    final sanitizedSize = size.replaceAll(RegExp(r'[.#$/\[\]]'), '_');
    final compositeKey = '${productKey}_$sanitizedSize';

    final cartRef = _db.child('users/${u.uid}/cart/$compositeKey');
    final snap = await cartRef.get();

    if (snap.exists && snap.value is Map) {
      final current = Map<String, dynamic>.from(snap.value as Map);
      final int currQty = (current['quantity'] ?? 0) is int
          ? current['quantity'] as int
          : int.tryParse('${current['quantity']}') ?? 0;

      await cartRef.update({'quantity': currQty + 1});
      return;
    }

    await cartRef.set({
      'name': name,
      'mainImageUrl': imageUrl,
      'selectedSize': size,
      'selectedPrice': price,
      'quantity': 1,
    });
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> fetchProductDetails(
      List<String> productKeys) async {
    final Map<String, Map<String, dynamic>?> result = {};
    final futures = productKeys.map((key) async {
      try {
        final snapshot = await _db.child('products/$key').get();
        if (snapshot.exists && snapshot.value != null) {
          result[key] = Map<String, dynamic>.from(snapshot.value as Map);
        } else {
          result[key] = null;
        }
      } catch (_) {
        result[key] = null;
      }
    }).toList();
    await Future.wait(futures);
    return result;
  }
}
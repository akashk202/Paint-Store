import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Contract for the cart remote data source.
abstract class CartRemoteDataSource {
  /// Stream of cart items for the current user.
  Stream<Map<String, Map<String, dynamic>>> cartStream();

  /// Update the quantity of a cart item. Removes if quantity <= 0.
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  });

  /// Change the selected pack size for a cart item.
  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  });

  /// Remove a single item from the cart.
  Future<void> removeItem(String productKey);

  /// Clear the entire cart.
  Future<void> clearCart();

  /// Add a new item or increment quantity if same size already in cart.
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String mainImageUrl,
    required String size,
    required String price,
  });
}

/// Implementation wrapping Firebase Realtime Database.
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;

  CartRemoteDataSourceImpl({
    FirebaseAuth? auth,
    DatabaseReference? dbRef,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _dbRef = dbRef ?? FirebaseDatabase.instance.ref();

  User? get _user => _auth.currentUser;

  @override
  Stream<Map<String, Map<String, dynamic>>> cartStream() {
    final u = _user;
    if (u == null) return const Stream.empty();

    return _dbRef.child('users/${u.uid}/cart').onValue.map((event) {
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
      await _dbRef.child('users/${u.uid}/cart/$productKey').remove();
    } else {
      await _dbRef
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
    await _dbRef.child('users/${u.uid}/cart/$productKey').update({
      'selectedSize': size,
      'selectedPrice': price,
      'quantity': 1,
    });
  }

  @override
  Future<void> removeItem(String productKey) async {
    final u = _user;
    if (u == null) return;
    await _dbRef.child('users/${u.uid}/cart/$productKey').remove();
  }

  @override
  Future<void> clearCart() async {
    final u = _user;
    if (u == null) return;
    await _dbRef.child('users/${u.uid}/cart').remove();
  }

  @override
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String mainImageUrl,
    required String size,
    required String price,
  }) async {
    final u = _user;
    if (u == null) return;
    final cartRef = _dbRef.child('users/${u.uid}/cart/$productKey');
    final snap = await cartRef.get();
    if (snap.exists && snap.value is Map) {
      final current = Map<String, dynamic>.from(snap.value as Map);
      if ((current['selectedSize'] ?? '') == size) {
        final int currQty = (current['quantity'] ?? 0) is int
            ? current['quantity'] as int
            : int.tryParse('${current['quantity']}') ?? 0;
        await cartRef.update({'quantity': currQty + 1});
        return;
      }
    }
    await cartRef.set({
      'name': name,
      'mainImageUrl': mainImageUrl,
      'selectedSize': size,
      'selectedPrice': price,
      'quantity': 1,
    });
  }
}

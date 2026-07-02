import 'package:firebase_database/firebase_database.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('products');

  Future<List<Product>> fetchAll() async {
    final snapshot = await _ref.get();
    if (!snapshot.exists || snapshot.value == null) return [];
    final map = Map<String, dynamic>.from(snapshot.value as Map);
    final List<Product> products = [];
    map.forEach((key, value) {
      try {
        products.add(ProductModel.fromMap(key, Map<String, dynamic>.from(value)));
      } catch (_) {
        // Ignore malformed items
      }
    });
    return products;
  }

  Stream<DatabaseEvent> productsStream() {
    return _ref.orderByChild('name').onValue;
  }

  Future<void> updateProduct(String key, Map<String, dynamic> data) async {
    await _ref.child(key).update(data);
  }

  Future<void> deleteProduct(String key) async {
    await _ref.child(key).remove();
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    await _ref.push().set(data);
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';import '../models/home_product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeProductModel>> fetchAllProducts();

  Stream<int> unreadCountStream(String uid);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseDatabase database;

  HomeRemoteDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<HomeProductModel>> fetchAllProducts() async {
    final ref = database.ref('products');
    final snapshot = await ref.get();
    if (!snapshot.exists || snapshot.value == null) {
      return <HomeProductModel>[];
    }

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    final List<HomeProductModel> products = <HomeProductModel>[];
    map.forEach((key, value) {
      try {
        final product = ProductModel.fromMap(key, Map<String, dynamic>.from(value));
        products.add(HomeProductModel.fromProduct(product));
      } catch (_) {
        // Skip malformed products and keep rendering the rest.
      }
    });
    return products;
  }

  @override
  Stream<int> unreadCountStream(String uid) {
    final ref = database.ref('users/$uid/notifications').limitToLast(200);
    return ref.onValue.map<int>((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return 0;
      try {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        var count = 0;
        map.forEach((_, value) {
          final notification = Map<String, dynamic>.from(value as Map);
          if (notification['isRead'] == false) {
            count++;
          }
        });
        return count;
      } catch (_) {
        return 0;
      }
    }).handleError((_) => 0);
  }
}

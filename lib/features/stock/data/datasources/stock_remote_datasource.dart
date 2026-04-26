import 'package:firebase_database/firebase_database.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';abstract class StockRemoteDataSource {
  Stream<List<Product>> watchStock();
  Future<void> updateStock(String productKey, int newStock);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final DatabaseReference dbRef;

  StockRemoteDataSourceImpl(this.dbRef);

  @override
  Stream<List<Product>> watchStock() {
    return dbRef.child('products').onValue.map((event) {
      if (!event.snapshot.exists || event.snapshot.value == null) {
        return <Product>[];
      }
      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Product> products = [];
      map.forEach((key, value) {
        try {
          products.add(Product.fromMap(key, Map<String, dynamic>.from(value)));
        } catch (_) {}
      });
      return products;
    });
  }

  @override
  Future<void> updateStock(String productKey, int newStock) async {
    final stockToUpdate = newStock < 0 ? 0 : newStock;
    await dbRef.child('products').child(productKey).update({'stock': stockToUpdate});
  }
}

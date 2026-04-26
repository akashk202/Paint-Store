import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchAll();
  Future<void> updateProduct(String key, Map<String, dynamic> data);
  Future<void> deleteProduct(String key);
  Future<void> addProduct(Map<String, dynamic> data);
}

import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Product>> fetchAll() => _remoteDataSource.fetchAll();

  @override
  Future<void> updateProduct(String key, Map<String, dynamic> data) => _remoteDataSource.updateProduct(key, data);

  @override
  Future<void> deleteProduct(String key) => _remoteDataSource.deleteProduct(key);

  @override
  Future<void> addProduct(Map<String, dynamic> data) => _remoteDataSource.addProduct(data);

  @override
  Stream<List<Product>> productsStream() {
    return _remoteDataSource.productsStream().map((event) {
      if (event.snapshot.value == null) return [];
      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Product> products = [];
      map.forEach((key, value) {
        try {
          products.add(ProductModel.fromMap(key, Map<String, dynamic>.from(value)));
        } catch (_) {}
      });
      return products;
    });
  }
}

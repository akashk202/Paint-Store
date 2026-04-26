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
}

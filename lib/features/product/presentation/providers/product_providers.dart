import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(dataSource);
});

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRemoteDataSourceProvider).productsStream().map((event) {
    if (event.snapshot.value == null) return [];
    final map = Map<String, dynamic>.from(event.snapshot.value as Map);
    final List<Product> products = [];
    map.forEach((key, value) {
      try {
        products.add(Product.fromMap(key, Map<String, dynamic>.from(value)));
      } catch (_) {}
    });
    return products;
  });
});

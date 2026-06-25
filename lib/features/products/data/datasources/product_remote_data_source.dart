import 'package:firebase_database/firebase_database.dart';
import 'package:c_h_p/core/error/exceptions.dart';
import 'package:c_h_p/features/products/data/models/product_model.dart';

/// Contract for the product remote data source.
abstract class ProductRemoteDataSource {
  /// Fetch all products from Firebase Realtime Database.
  Future<List<ProductModel>> fetchAllProducts();

  /// Search products by name (client-side filtering after fetch).
  Future<List<ProductModel>> searchProducts(String query);
}

/// Implementation wrapping Firebase Realtime Database.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DatabaseReference _ref;

  ProductRemoteDataSourceImpl({DatabaseReference? ref})
      : _ref = ref ?? FirebaseDatabase.instance.ref('products');

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final snapshot = await _ref.get();
      if (!snapshot.exists || snapshot.value == null) return [];

      final map = Map<String, dynamic>.from(snapshot.value as Map);
      final List<ProductModel> products = [];
      map.forEach((key, value) {
        try {
          products.add(
              ProductModel.fromMap(key, Map<String, dynamic>.from(value)));
        } catch (_) {
          // Skip malformed entries
        }
      });
      return products;
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final allProducts = await fetchAllProducts();
      final q = query.toLowerCase().trim();
      if (q.isEmpty) return allProducts;

      return allProducts.where((product) {
        final name = product.name.toLowerCase();
        final brand = (product.brand ?? '').toLowerCase();
        final category = (product.category ?? '').toLowerCase();
        return name.contains(q) ||
            brand.contains(q) ||
            category.contains(q);
      }).toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Search failed: ${e.toString()}');
    }
  }
}

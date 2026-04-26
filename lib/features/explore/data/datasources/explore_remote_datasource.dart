import 'package:c_h_p/features/explore/data/datasources/recommendation_remote_datasource.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';import 'package:firebase_database/firebase_database.dart';

import '../models/explore_product_model.dart';

abstract class ExploreRemoteDataSource {
  Future<List<ExploreProductModel>> fetchRecommended({int limit = 10});
  Future<List<ExploreProductModel>> searchProducts(String query);
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  Future<List<ExploreProductModel>> fetchRecommended({int limit = 10}) async {
    final products =
        await RecommendationRemoteDataSource.fetchRecommendedProducts(limit: limit);
    return products.map(ExploreProductModel.fromProduct).toList();
  }

  @override
  Future<List<ExploreProductModel>> searchProducts(String query) async {
    final snapshot = await _dbRef.child('products').get();
    if (!snapshot.exists || snapshot.value == null) return [];
    
    final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
    final List<Product> allProducts = [];

    productsMap.forEach((key, value) {
      try {
        allProducts.add(Product.fromMap(key, Map<String, dynamic>.from(value)));
      } catch (_) {}
    });

    final lowerQuery = query.toLowerCase();
    final filtered = allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(lowerQuery);
      final categoryMatch = (product.category ?? '').toLowerCase().contains(lowerQuery);
      final subCategoryMatch = (product.subCategory ?? '').toLowerCase().contains(lowerQuery);
      return nameMatch || categoryMatch || subCategoryMatch;
    }).toList();

    return filtered.map(ExploreProductModel.fromProduct).toList();
  }
}

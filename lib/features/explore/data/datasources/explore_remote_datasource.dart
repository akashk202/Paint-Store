import 'package:c_h_p/features/explore/data/datasources/recommendation_remote_datasource.dart';

import 'package:c_h_p/features/product/data/models/product_model.dart';import 'package:firebase_database/firebase_database.dart';

import '../models/explore_product_model.dart';

abstract class ExploreRemoteDataSource {
  Future<List<ExploreProductModel>> fetchRecommended({int limit = 10});
  Future<List<ExploreProductModel>> searchProducts(String query);
  Future<List<ExploreProductModel>> fetchProductsByFilter({
    String? category,
    String? subCategory,
    String? brand,
  });
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

  @override
  Future<List<ExploreProductModel>> fetchProductsByFilter({
    String? category,
    String? subCategory,
    String? brand,
  }) async {
    Query query = _dbRef.child('products');
    if (category != null) {
      query = query.orderByChild('category').equalTo(category);
    } else if (subCategory != null) {
      query = query.orderByChild('subCategory').equalTo(subCategory);
    }

    final snapshot = await query.get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
    final List<Product> products = [];
    productsMap.forEach((key, value) {
      try {
        products.add(Product.fromMap(key, Map<String, dynamic>.from(value)));
      } catch (_) {}
    });

    var list = products.where((p) => p.stock > 0).toList();

    // Filter by subCategory if both category and subCategory provided
    if (category != null && subCategory != null && subCategory.isNotEmpty) {
      list = list.where((p) => (p.subCategory ?? '') == subCategory).toList();
    }

    // Filter by brand
    if (brand != null && brand.isNotEmpty) {
      final b = brand.toLowerCase();
      list = list.where((p) {
        final pb = (p.brand ?? '').toLowerCase();
        return pb == b || pb.startsWith(b);
      }).toList();
    }

    list.sort((a, b) => a.name.compareTo(b.name));
    return list.map(ExploreProductModel.fromProduct).toList();
  }
}

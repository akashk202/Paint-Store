import '../entities/explore_product_entity.dart';

abstract class ExploreRepository {
  Future<List<ExploreProductEntity>> fetchRecommended({int limit = 10});
  Future<List<ExploreProductEntity>> searchProducts(String query);
}

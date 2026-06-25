import '../../../product/data/models/product_model.dart';
import '../entities/explore_product_entity.dart';

abstract class ExploreRepository {
  Future<List<ExploreProductEntity>> fetchRecommended({int limit = 10});
  Future<List<ExploreProductEntity>> searchProducts(String query);
  Future<List<ExploreProductEntity>> fetchProductsByFilter({
    String? category,
    String? subCategory,
    String? brand,
  });
  Future<List<ExploreProductEntity>> fetchSimilarProducts(Product anchor, {int limit = 10});
}

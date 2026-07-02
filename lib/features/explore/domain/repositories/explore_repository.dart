import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
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


// Either<Failure, T>

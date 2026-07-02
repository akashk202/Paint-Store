import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../entities/explore_product_entity.dart';

abstract class ExploreRepository {
  Future<Either<Failure, List<ExploreProductEntity>>> fetchRecommended({int limit = 10});
  Future<Either<Failure, List<ExploreProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<ExploreProductEntity>>> fetchProductsByFilter({
    String? category,
    String? subCategory,
    String? brand,
  });
  Future<Either<Failure, List<ExploreProductEntity>>> fetchSimilarProducts(Product anchor, {int limit = 10});
}

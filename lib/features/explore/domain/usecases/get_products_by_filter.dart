import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

/// Use case: fetches products filtered by category, subCategory, and/or brand.
class GetProductsByFilter {
  final ExploreRepository repository;

  GetProductsByFilter(this.repository);

  Future<List<ExploreProductEntity>> call({
    String? category,
    String? subCategory,
    String? brand,
  }) {
    return repository.fetchProductsByFilter(
      category: category,
      subCategory: subCategory,
      brand: brand,
    );
  }
}

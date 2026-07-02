import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class SearchProducts {
  final ExploreRepository repository;

  SearchProducts(this.repository);

  Future<List<ExploreProductEntity>> call(String query) {
    return repository.searchProducts(query);
  }
}


// implements UseCase

import '../entities/explore_product_entity.dart';

import '../repositories/explore_repository.dart';

class GetRecommendedProducts {
  final ExploreRepository repository;

  GetRecommendedProducts(this.repository);

  Future<List<ExploreProductEntity>> call({int limit = 10}) {
    return repository.fetchRecommended(limit: limit);
  }
}


// implements UseCase

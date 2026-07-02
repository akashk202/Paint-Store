import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetSimilarProducts {
  final ExploreRepository repository;

  GetSimilarProducts(this.repository);

  Future<List<ExploreProductEntity>> call(Product anchor, {int limit = 10}) {
    return repository.fetchSimilarProducts(anchor, limit: limit);
  }
}


// implements UseCase

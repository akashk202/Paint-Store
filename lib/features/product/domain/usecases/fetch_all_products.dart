import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class FetchAllProducts {
  final ProductRepository repository;

  FetchAllProducts(this.repository);

  Future<List<Product>> call() {
    return repository.fetchAll();
  }
}


// implements UseCase

import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsStream {
  final ProductRepository repository;

  GetProductsStream(this.repository);

  Stream<List<Product>> call() {
    return repository.productsStream();
  }
}


// implements UseCase

import '../../data/models/product_model.dart';
import '../repositories/product_repository.dart';

class FetchAllProducts {
  final ProductRepository repository;

  FetchAllProducts(this.repository);

  Future<List<Product>> call() {
    return repository.fetchAll();
  }
}

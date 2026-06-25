import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<void> call(String key) {
    return repository.deleteProduct(key);
  }
}

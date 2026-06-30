import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<void> call(String key, Map<String, dynamic> data) {
    return repository.updateProduct(key, data);
  }
}

import '../repositories/cart_repository.dart';

class FetchProductDetails {
  final CartRepository repository;

  FetchProductDetails(this.repository);

  Future<Map<String, Map<String, dynamic>?>> call(List<String> productKeys) {
    return repository.fetchProductDetails(productKeys);
  }
}

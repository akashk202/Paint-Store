import '../../domain/repositories/cart_repository.dart';

class RemoveItem {
  final CartRepository repository;

  RemoveItem(this.repository);

  Future<void> call(String productKey) {
    return repository.removeItem(productKey);
  }
}
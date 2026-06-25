import '../../domain/repositories/cart_repository.dart';

class UpdateQuantity {
  final CartRepository repository;

  UpdateQuantity(this.repository);

  Future<void> call(String productKey, int quantity) {
    return repository.updateQuantity(
      productKey: productKey,
      quantity: quantity,
    );
  }
}
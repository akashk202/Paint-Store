import '../../domain/repositories/cart_repository.dart';

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  Future<void> call() {
    return repository.clearCart();
  }
}

// implements UseCase

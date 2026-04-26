import '../../domain/repositories/cart_repository.dart';

class ChangeSize {
  final CartRepository repository;

  ChangeSize(this.repository);

  Future<void> call({
    required String productKey,
    required String size,
    required String price,
  }) {
    return repository.changeSize(
      productKey: productKey,
      size: size,
      price: price,
    );
  }
}
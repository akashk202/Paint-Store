import '../../domain/repositories/cart_repository.dart';

class AddOrUpdateItem {
  final CartRepository repository;

  AddOrUpdateItem(this.repository);

  Future<void> call({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  }) {
    return repository.addOrUpdateItem(
      productKey: productKey,
      name: name,
      imageUrl: imageUrl,
      size: size,
      price: price,
    );
  }
}

// implements UseCase

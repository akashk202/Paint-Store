import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;

  CartRepositoryImpl(this.remote);

  @override
  Stream<List<CartItem>> cartStream() {
    return remote.cartStream().map((map) {
      return map.entries.map((e) {
        return CartItemModel.fromMap(e.key, e.value);
      }).toList();
    });
  }

  @override
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  }) {
    return remote.updateQuantity(
      productKey: productKey,
      quantity: quantity,
    );
  }

  @override
  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  }) {
    return remote.changeSize(
      productKey: productKey,
      size: size,
      price: price,
    );
  }

  @override
  Future<void> removeItem(String productKey) {
    return remote.removeItem(productKey);
  }

  @override
  Future<void> clearCart() {
    return remote.clearCart();
  }

  @override
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  }) {
    return remote.addOrUpdateItem(
      productKey: productKey,
      name: name,
      imageUrl: imageUrl,
      size: size,
      price: price,
    );
  }

  @override
  Future<Map<String, Map<String, dynamic>?>> fetchProductDetails(
    List<String> productKeys,
  ) {
    return remote.fetchProductDetails(productKeys);
  }
}
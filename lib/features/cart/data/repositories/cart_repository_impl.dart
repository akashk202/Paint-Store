import 'package:c_h_p/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:c_h_p/features/cart/domain/repositories/cart_repository.dart';

/// Concrete implementation of [CartRepository].
/// Delegates all operations to [CartRemoteDataSource].
class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Map<String, Map<String, dynamic>>> cartStream() {
    return remoteDataSource.cartStream();
  }

  @override
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  }) {
    return remoteDataSource.updateQuantity(
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
    return remoteDataSource.changeSize(
      productKey: productKey,
      size: size,
      price: price,
    );
  }

  @override
  Future<void> removeItem(String productKey) {
    return remoteDataSource.removeItem(productKey);
  }

  @override
  Future<void> clearCart() {
    return remoteDataSource.clearCart();
  }

  @override
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String mainImageUrl,
    required String size,
    required String price,
  }) {
    return remoteDataSource.addOrUpdateItem(
      productKey: productKey,
      name: name,
      mainImageUrl: mainImageUrl,
      size: size,
      price: price,
    );
  }
}

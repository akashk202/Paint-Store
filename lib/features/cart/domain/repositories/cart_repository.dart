import '../entities/cart_item.dart';
abstract class CartRepository {
  Stream<List<CartItem>> cartStream();

  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  });

  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  });

  Future<void> removeItem(String productKey);

  Future<void> clearCart();

  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  });

  Future<Map<String, Map<String, dynamic>?>> fetchProductDetails(
    List<String> productKeys,
  );
}
/// Abstract contract for cart data operations.
/// The data layer provides the implementation.
abstract class CartRepository {
  /// Stream of cart items for the current user.
  Stream<Map<String, Map<String, dynamic>>> cartStream();

  /// Update the quantity of a cart item.
  Future<void> updateQuantity({
    required String productKey,
    required int quantity,
  });

  /// Change the selected size/price of a cart item.
  Future<void> changeSize({
    required String productKey,
    required String size,
    required String price,
  });

  /// Remove a single item from the cart.
  Future<void> removeItem(String productKey);

  /// Clear the entire cart.
  Future<void> clearCart();

  /// Add a new item or update existing item in the cart.
  Future<void> addOrUpdateItem({
    required String productKey,
    required String name,
    required String mainImageUrl,
    required String size,
    required String price,
  });
}

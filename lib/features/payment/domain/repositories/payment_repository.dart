abstract class PaymentRepository {
  Future<List<String>> fetchCartItemNames();

  Future<String?> saveOrder({
    required String paymentId,
    String? signature,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
    required List<String> items,
  });

  Future<void> sendPurchaseNotifications({
    required List<String> productNames,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
  });

  Future<void> clearCart();
}

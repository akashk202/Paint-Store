import '../repositories/payment_repository.dart';

class HandlePaymentSuccess {
  final PaymentRepository repository;

  HandlePaymentSuccess(this.repository);

  Future<String?> call({
    required String paymentId,
    String? signature,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
  }) async {
    // 1. Fetch current items in cart to attach to order
    final items = await repository.fetchCartItemNames();
    
    // 2. Save the order to DB
    final orderId = await repository.saveOrder(
      paymentId: paymentId,
      signature: signature,
      totalAmountPaise: totalAmountPaise,
      deliveryAddress: deliveryAddress,
      lat: lat,
      lng: lng,
      fullName: fullName,
      email: email,
      phone: phone,
      items: items,
    );
    
    // 3. Send notifications to admins and user
    await repository.sendPurchaseNotifications(
      productNames: items,
      totalAmountPaise: totalAmountPaise,
      deliveryAddress: deliveryAddress,
      lat: lat,
      lng: lng,
      fullName: fullName,
      email: email,
      phone: phone,
    );
    
    // 4. Clear the cart
    await repository.clearCart();
    
    return orderId;
  }
}

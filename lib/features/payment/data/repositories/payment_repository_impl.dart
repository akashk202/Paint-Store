import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<String>> fetchCartItemNames() {
    return remoteDataSource.fetchCartItemNames();
  }

  @override
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
  }) {
    return remoteDataSource.saveOrder(
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
  }

  @override
  Future<void> sendPurchaseNotifications({
    required List<String> productNames,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
  }) {
    return remoteDataSource.sendPurchaseNotifications(
      productNames: productNames,
      totalAmountPaise: totalAmountPaise,
      deliveryAddress: deliveryAddress,
      lat: lat,
      lng: lng,
      fullName: fullName,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<void> clearCart() {
    return remoteDataSource.clearCart();
  }
}

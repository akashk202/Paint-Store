import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<String>>> fetchCartItemNames();

  Future<Either<Failure, String?>> saveOrder({
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

  Future<Either<Failure, void>> sendPurchaseNotifications({
    required List<String> productNames,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
  });

  Future<Either<Failure, void>> clearCart();
}

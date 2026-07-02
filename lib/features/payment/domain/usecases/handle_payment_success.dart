import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/payment_repository.dart';

class HandlePaymentSuccess implements UseCase<String?, HandlePaymentSuccessParams> {
  final PaymentRepository repository;

  HandlePaymentSuccess(this.repository);

  @override
  Future<Either<Failure, String?>> call(HandlePaymentSuccessParams params) async {
    // 1. Fetch current items in cart to attach to order
    final itemsResult = await repository.fetchCartItemNames();
    
    return itemsResult.fold(
      (failure) => Left(failure),
      (items) async {
        // 2. Save the order to DB
        final orderResult = await repository.saveOrder(
          paymentId: params.paymentId,
          signature: params.signature,
          totalAmountPaise: params.totalAmountPaise,
          deliveryAddress: params.deliveryAddress,
          lat: params.lat,
          lng: params.lng,
          fullName: params.fullName,
          email: params.email,
          phone: params.phone,
          items: items,
        );
        
        return orderResult.fold(
          (failure) => Left(failure),
          (orderId) async {
            // 3. Send notifications to admins and user
            final notifyResult = await repository.sendPurchaseNotifications(
              productNames: items,
              totalAmountPaise: params.totalAmountPaise,
              deliveryAddress: params.deliveryAddress,
              lat: params.lat,
              lng: params.lng,
              fullName: params.fullName,
              email: params.email,
              phone: params.phone,
            );
            
            return notifyResult.fold(
              (failure) => Left(failure),
              (_) async {
                // 4. Clear the cart
                final clearResult = await repository.clearCart();
                return clearResult.fold(
                  (failure) => Left(failure),
                  (_) => Right(orderId),
                );
              },
            );
          },
        );
      },
    );
  }
}

class HandlePaymentSuccessParams extends Equatable {
  final String paymentId;
  final String? signature;
  final int totalAmountPaise;
  final String? deliveryAddress;
  final double? lat;
  final double? lng;
  final String? fullName;
  final String? email;
  final String? phone;

  const HandlePaymentSuccessParams({
    required this.paymentId,
    this.signature,
    required this.totalAmountPaise,
    this.deliveryAddress,
    this.lat,
    this.lng,
    this.fullName,
    this.email,
    this.phone,
  });

  @override
  List<Object?> get props => [
        paymentId,
        signature,
        totalAmountPaise,
        deliveryAddress,
        lat,
        lng,
        fullName,
        email,
        phone,
      ];
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/handle_payment_success.dart';
import 'payment_state.dart';

class PaymentNotifier extends StateNotifier<PaymentState> {
  final HandlePaymentSuccess handlePaymentSuccessUseCase;

  PaymentNotifier({
    required this.handlePaymentSuccessUseCase,
  }) : super(const PaymentState());

  Future<String?> handlePaymentSuccess({
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
    state = state.copyWith(processing: true, completed: false, error: null);
    
    final result = await handlePaymentSuccessUseCase(
      HandlePaymentSuccessParams(
        paymentId: paymentId,
        signature: signature,
        totalAmountPaise: totalAmountPaise,
        deliveryAddress: deliveryAddress,
        lat: lat,
        lng: lng,
        fullName: fullName,
        email: email,
        phone: phone,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(processing: false, completed: false, error: failure.message);
        return null;
      },
      (orderId) {
        state = state.copyWith(
            processing: false, completed: true, lastOrderId: orderId);
        return orderId;
      },
    );
  }
}

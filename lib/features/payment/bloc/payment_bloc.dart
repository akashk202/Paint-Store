import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/orders_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

export 'payment_event.dart';
export 'payment_state.dart';

/// PaymentBloc: handles post-payment order saving and notifications.
/// Uses [OrdersRepository] to persist orders and send notifications.
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final OrdersRepository ordersRepository;

  PaymentBloc({required this.ordersRepository})
      : super(const PaymentInitial()) {
    on<PaymentSucceeded>(_onPaymentSucceeded);
    on<PaymentFailed>(_onPaymentFailed);
    on<ResetPayment>(_onReset);
  }

  Future<void> _onPaymentSucceeded(
    PaymentSucceeded event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());
    try {
      // Save the order
      final orderId = await ordersRepository.saveOrder(
        paymentId: event.paymentId,
        signature: event.signature,
        totalAmountPaise: event.totalAmountPaise,
        deliveryAddress: event.deliveryAddress,
        lat: event.lat,
        lng: event.lng,
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        items: event.items,
      );

      // Send notifications
      await ordersRepository.sendPurchaseNotifications(
        productNames: event.items,
        totalAmountPaise: event.totalAmountPaise,
        deliveryAddress: event.deliveryAddress,
        lat: event.lat,
        lng: event.lng,
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
      );

      // Clear the cart after successful order
      await ordersRepository.clearCart();

      emit(PaymentOrderSaved(orderId ?? 'unknown'));
    } catch (e) {
      emit(PaymentFailureState('Order failed: ${e.toString()}'));
    }
  }

  void _onPaymentFailed(
    PaymentFailed event,
    Emitter<PaymentState> emit,
  ) {
    emit(PaymentFailureState(event.errorMessage));
  }

  void _onReset(
    ResetPayment event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}

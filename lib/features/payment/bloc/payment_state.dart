import 'package:equatable/equatable.dart';

/// States emitted by the PaymentBloc.
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state — ready for payment.
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Payment/order processing in progress.
class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

/// Order saved successfully after payment.
class PaymentOrderSaved extends PaymentState {
  final String orderId;

  const PaymentOrderSaved(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Payment failed.
class PaymentFailureState extends PaymentState {
  final String message;

  const PaymentFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

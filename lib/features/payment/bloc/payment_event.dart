import 'package:equatable/equatable.dart';

/// Events dispatched by the Payment UI to the PaymentBloc.
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Payment was successful — save the order.
class PaymentSucceeded extends PaymentEvent {
  final String paymentId;
  final String? signature;
  final int totalAmountPaise;
  final String? deliveryAddress;
  final double? lat;
  final double? lng;
  final String? fullName;
  final String? email;
  final String? phone;
  final List<String> items;

  const PaymentSucceeded({
    required this.paymentId,
    this.signature,
    required this.totalAmountPaise,
    this.deliveryAddress,
    this.lat,
    this.lng,
    this.fullName,
    this.email,
    this.phone,
    required this.items,
  });

  @override
  List<Object?> get props => [paymentId, totalAmountPaise, items];
}

/// Payment failed.
class PaymentFailed extends PaymentEvent {
  final String errorMessage;

  const PaymentFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

/// Reset payment state (e.g. to allow retry).
class ResetPayment extends PaymentEvent {
  const ResetPayment();
}

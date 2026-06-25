import 'package:equatable/equatable.dart';

/// States emitted by the CheckoutBloc.
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state before checkout data is loaded.
class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

/// Checkout data is being loaded.
class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

/// User profile loaded for checkout form.
class CheckoutProfileLoaded extends CheckoutState {
  final Map<String, dynamic>? profile;
  final List<String> cartItemNames;

  const CheckoutProfileLoaded({
    this.profile,
    this.cartItemNames = const [],
  });

  CheckoutProfileLoaded copyWith({
    Map<String, dynamic>? profile,
    List<String>? cartItemNames,
  }) {
    return CheckoutProfileLoaded(
      profile: profile ?? this.profile,
      cartItemNames: cartItemNames ?? this.cartItemNames,
    );
  }

  @override
  List<Object?> get props => [profile, cartItemNames];
}

/// Profile updated successfully.
class CheckoutProfileUpdated extends CheckoutState {
  const CheckoutProfileUpdated();
}

/// An error occurred during checkout operations.
class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

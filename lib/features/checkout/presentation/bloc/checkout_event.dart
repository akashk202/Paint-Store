import 'package:equatable/equatable.dart';

/// Events dispatched by the Checkout UI to the CheckoutBloc.
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile for pre-filling checkout form.
class LoadUserProfile extends CheckoutEvent {
  const LoadUserProfile();
}

/// Update the user's delivery profile.
class UpdateUserProfile extends CheckoutEvent {
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final double? lat;
  final double? lng;

  const UpdateUserProfile({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    this.lat,
    this.lng,
  });

  @override
  List<Object?> get props => [fullName, phone, email, address, lat, lng];
}

/// Fetch item names from the cart for order summary.
class FetchCartItemNames extends CheckoutEvent {
  const FetchCartItemNames();
}

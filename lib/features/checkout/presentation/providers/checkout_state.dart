import '../../domain/entities/checkout_profile.dart';

class CheckoutState {
  final bool loading;
  final String name;
  final String phone;
  final String email;
  final String address;
  final double? lat;
  final double? lng;
  final Object? error;

  const CheckoutState({
    this.loading = false,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.lat,
    this.lng,
    this.error,
  });

  CheckoutState copyWith({
    bool? loading,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? lat,
    double? lng,
    Object? error,
  }) {
    return CheckoutState(
      loading: loading ?? this.loading,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      error: error,
    );
  }

  CheckoutProfile toProfile() {
    return CheckoutProfile(
      name: name,
      phone: phone,
      email: email,
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
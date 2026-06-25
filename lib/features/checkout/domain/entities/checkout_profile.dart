class CheckoutProfile {
  final String name;
  final String phone;
  final String email;
  final String address;
  final double? lat;
  final double? lng;

  const CheckoutProfile({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.lat,
    this.lng,
  });

  CheckoutProfile copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    double? lat,
    double? lng,
  }) {
    return CheckoutProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}
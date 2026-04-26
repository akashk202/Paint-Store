import '../../domain/entities/checkout_profile.dart';

class CheckoutProfileModel extends CheckoutProfile {
  const CheckoutProfileModel({
    super.name,
    super.phone,
    super.email,
    super.address,
    super.lat,
    super.lng,
  });

  factory CheckoutProfileModel.fromRemote({
    required Map<String, String> signedInUser,
    required Map<String, dynamic>? profileMap,
  }) {
    return CheckoutProfileModel(
      name: signedInUser['name']?.isNotEmpty == true
          ? signedInUser['name']!
          : (profileMap?['fullName'] ?? '').toString(),
      phone: signedInUser['phone']?.isNotEmpty == true
          ? signedInUser['phone']!
          : (profileMap?['phone'] ?? '').toString(),
      email: signedInUser['email']?.isNotEmpty == true
          ? signedInUser['email']!
          : (profileMap?['email'] ?? '').toString(),
      address: (profileMap?['address'] ?? '').toString(),
      lat: (profileMap?['location']?['lat'] as num?)?.toDouble(),
      lng: (profileMap?['location']?['lng'] as num?)?.toDouble(),
    );
  }
}

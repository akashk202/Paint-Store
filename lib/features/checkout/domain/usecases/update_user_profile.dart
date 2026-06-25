import '../repositories/checkout_repository.dart';

class UpdateUserProfile {
  final CheckoutRepository repository;

  UpdateUserProfile(this.repository);

  Future<void> call({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  }) {
    return repository.updateUserProfile(
      fullName: fullName,
      phone: phone,
      email: email,
      address: address,
      lat: lat,
      lng: lng,
    );
  }
}
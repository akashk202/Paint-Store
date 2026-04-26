import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<void> call({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  }) {
    return repository.updateUserProfile(
      name: name,
      phone: phone,
      address: address,
      pincode: pincode,
      lat: lat,
      lng: lng,
    );
  }
}

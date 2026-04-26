import '../../domain/entities/checkout_profile.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';
import '../models/checkout_profile_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remote;

  CheckoutRepositoryImpl(this.remote);

  @override
  Future<CheckoutProfile?> fetchUserProfile() async {
    final signedInUser = remote.fetchSignedInUserDetails();
    final profileMap = await remote.fetchUserProfile();

    if (profileMap == null &&
        signedInUser.values.every((value) => value.isEmpty)) {
      return null;
    }

    return CheckoutProfileModel.fromRemote(
      signedInUser: signedInUser,
      profileMap: profileMap,
    );
  }

  @override
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  }) {
    return remote.updateUserProfile(
      fullName: fullName,
      phone: phone,
      email: email,
      address: address,
      lat: lat,
      lng: lng,
    );
  }

  @override
  Future<List<String>> fetchCartItemNames() {
    return remote.fetchCartItemNames();
  }
}

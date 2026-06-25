import 'package:c_h_p/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:c_h_p/features/checkout/domain/repositories/checkout_repository.dart';

/// Concrete implementation of [CheckoutRepository].
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>?> fetchUserProfile() {
    return remoteDataSource.fetchUserProfile();
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
    return remoteDataSource.updateUserProfile(
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
    return remoteDataSource.fetchCartItemNames();
  }
}

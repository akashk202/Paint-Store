import '../entities/checkout_profile.dart';

abstract class CheckoutRepository {
  Future<CheckoutProfile?> fetchUserProfile();
  
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  });

  Future<List<String>> fetchCartItemNames();
}
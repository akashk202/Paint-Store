/// Abstract contract for checkout operations.
abstract class CheckoutRepository {
  Future<Map<String, dynamic>?> fetchUserProfile();
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

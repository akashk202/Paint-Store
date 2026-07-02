import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/checkout/domain/entities/checkout_profile.dart';

void main() {
  group('CheckoutProfile Tests', () {
    test('should create CheckoutProfile with correct values', () {
      const profile = CheckoutProfile(
        name: 'John Doe',
        phone: '9876543210',
        email: 'john@example.com',
        address: '123 Street',
        lat: 12.34,
        lng: 56.78,
      );
      expect(profile.name, 'John Doe');
      expect(profile.phone, '9876543210');
      expect(profile.email, 'john@example.com');
      expect(profile.address, '123 Street');
      expect(profile.lat, 12.34);
      expect(profile.lng, 56.78);
    });
  });
}

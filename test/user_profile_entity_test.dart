import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/user/domain/entities/user_profile_entity.dart';

void main() {
  group('UserProfileEntity Tests', () {
    test('should create UserProfileEntity with correct values', () {
      const entity = UserProfileEntity(
        uid: 'user_123',
        email: 'alice@example.com',
        displayName: 'Alice',
        photoUrl: 'profile_pic_url',
        phone: '1112223333',
        address: '456 Avenue',
        pincode: '600001',
        role: 'Manager',
        lat: 10.0,
        lng: 20.0,
      );
      expect(entity.uid, 'user_123');
      expect(entity.email, 'alice@example.com');
      expect(entity.displayName, 'Alice');
      expect(entity.photoUrl, 'profile_pic_url');
      expect(entity.phone, '1112223333');
      expect(entity.address, '456 Avenue');
      expect(entity.pincode, '600001');
      expect(entity.role, 'Manager');
      expect(entity.lat, 10.0);
      expect(entity.lng, 20.0);
    });
  });
}

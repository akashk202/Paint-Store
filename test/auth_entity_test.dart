import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity Tests', () {
    test('should create UserEntity with correct values', () {
      const entity = UserEntity(
        uid: '123',
        email: 'test@example.com',
        name: 'Test User',
        photoUrl: 'photo_url',
        userType: 'User',
        status: 'approved',
      );
      expect(entity.uid, '123');
      expect(entity.email, 'test@example.com');
      expect(entity.name, 'Test User');
      expect(entity.photoUrl, 'photo_url');
      expect(entity.userType, 'User');
      expect(entity.status, 'approved');
    });
  });
}

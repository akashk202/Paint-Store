import 'dart:io';
import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  });
  Future<String> updateProfilePicture(File imageFile);
  Future<void> deleteProfilePicture();
  Future<void> updateUserPassword(String currentPassword, String newPassword);
  Future<String> fetchUserRole(String uid);
}

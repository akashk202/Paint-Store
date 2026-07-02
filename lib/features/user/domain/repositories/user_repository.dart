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
  Future<List<Map<String, dynamic>>> fetchPendingManagerRequests();
  Future<void> approveManagerRequest(String uid);
  Future<void> denyManagerRequest(String uid);
  Stream<Map<String, dynamic>> fetchAllUsersStream();
  Future<void> updateUserRole(String uid, String role);
  Future<void> deleteUser(String uid);
}



// Either<Failure, T>

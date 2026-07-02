import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  });
  Future<Either<Failure, String>> updateProfilePicture(File imageFile);
  Future<Either<Failure, void>> deleteProfilePicture();
  Future<Either<Failure, void>> updateUserPassword(String currentPassword, String newPassword);
  Future<Either<Failure, String>> fetchUserRole(String uid);
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchPendingManagerRequests();
  Future<Either<Failure, void>> approveManagerRequest(String uid);
  Future<Either<Failure, void>> denyManagerRequest(String uid);
  Stream<Map<String, dynamic>> fetchAllUsersStream();
  Future<Either<Failure, void>> updateUserRole(String uid, String role);
  Future<Either<Failure, void>> deleteUser(String uid);
}

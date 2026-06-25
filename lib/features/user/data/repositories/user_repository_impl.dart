import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfileEntity> getUserProfile() {
    return remoteDataSource.getUserProfile();
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  }) {
    return remoteDataSource.updateUserProfile(
      name: name,
      phone: phone,
      address: address,
      pincode: pincode,
      lat: lat,
      lng: lng,
    );
  }

  @override
  Future<String> updateProfilePicture(File imageFile) {
    return remoteDataSource.updateProfilePicture(imageFile);
  }

  @override
  Future<void> deleteProfilePicture() {
    return remoteDataSource.deleteProfilePicture();
  }

  @override
  Future<void> updateUserPassword(String currentPassword, String newPassword) {
    return remoteDataSource.updateUserPassword(currentPassword, newPassword);
  }

  @override
  Future<String> fetchUserRole(String uid) {
    return remoteDataSource.fetchUserRole(uid);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPendingManagerRequests() {
    return remoteDataSource.fetchPendingManagerRequests();
  }

  @override
  Future<void> approveManagerRequest(String uid) {
    return remoteDataSource.approveManagerRequest(uid);
  }

  @override
  Future<void> denyManagerRequest(String uid) {
    return remoteDataSource.denyManagerRequest(uid);
  }

  @override
  Stream<Map<String, dynamic>> fetchAllUsersStream() {
    return remoteDataSource.fetchAllUsersStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value as Map);
    });
  }

  @override
  Future<void> updateUserRole(String uid, String role) {
    return remoteDataSource.updateUserRole(uid, role);
  }

  @override
  Future<void> deleteUser(String uid) {
    return remoteDataSource.deleteUser(uid);
  }
}

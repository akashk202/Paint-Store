import 'dart:io';
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
}

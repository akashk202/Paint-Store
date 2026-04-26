import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/update_profile_picture.dart';
import '../../domain/usecases/update_user_password.dart';
import '../../domain/usecases/get_user_role.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;
  final UpdateProfilePicture _updateProfilePicture;
  final DeleteProfilePicture _deleteProfilePicture;
  final UpdateUserPassword _updateUserPassword;
  final GetUserRole _getUserRole;

  UserNotifier({
    required GetUserProfile getUserProfile,
    required UpdateUserProfile updateUserProfile,
    required UpdateProfilePicture updateProfilePicture,
    required DeleteProfilePicture deleteProfilePicture,
    required UpdateUserPassword updateUserPassword,
    required GetUserRole getUserRole,
  })  : _getUserProfile = getUserProfile,
        _updateUserProfile = updateUserProfile,
        _updateProfilePicture = updateProfilePicture,
        _deleteProfilePicture = deleteProfilePicture,
        _updateUserPassword = updateUserPassword,
        _getUserRole = getUserRole,
        super(const UserState());

  Future<void> loadProfile() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final profile = await _getUserProfile();
      state = state.copyWith(loading: false, profile: profile, role: profile.role);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> loadRole(String uid) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final role = await _getUserRole(uid);
      state = state.copyWith(loading: false, role: role);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _updateUserProfile(
        name: name,
        phone: phone,
        address: address,
        pincode: pincode,
        lat: lat,
        lng: lng,
      );
      // Reload profile to get fresh data
      final profile = await _getUserProfile();
      state = state.copyWith(loading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _updateProfilePicture(imageFile);
      final profile = await _getUserProfile();
      state = state.copyWith(loading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteProfilePicture() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _deleteProfilePicture();
      final profile = await _getUserProfile();
      state = state.copyWith(loading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _updateUserPassword(currentPassword, newPassword);
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      rethrow;
    }
  }
}

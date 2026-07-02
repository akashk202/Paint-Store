import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';

import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/update_profile_picture.dart';
import '../../domain/usecases/delete_profile_picture.dart';
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
    final result = await _getUserProfile(const NoParams());
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (profile) {
        state = state.copyWith(loading: false, profile: profile, role: profile.role);
      },
    );
  }

  Future<void> loadRole(String uid) async {
    state = state.copyWith(loading: true, error: null);
    final result = await _getUserRole(uid);
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (role) {
        state = state.copyWith(loading: false, role: role);
      },
    );
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
    final result = await _updateUserProfile(
      UpdateUserProfileParams(
        name: name,
        phone: phone,
        address: address,
        pincode: pincode,
        lat: lat,
        lng: lng,
      ),
    );
    
    await result.fold(
      (failure) async {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (_) async {
        // Reload profile to get fresh data
        final profileResult = await _getUserProfile(const NoParams());
        profileResult.fold(
          (failure) {
            state = state.copyWith(loading: false, error: failure.message);
          },
          (profile) {
            state = state.copyWith(loading: false, profile: profile);
          },
        );
      },
    );
  }

  Future<void> updateProfilePicture(File imageFile) async {
    state = state.copyWith(loading: true, error: null);
    final result = await _updateProfilePicture(imageFile);
    await result.fold(
      (failure) async {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (_) async {
        final profileResult = await _getUserProfile(const NoParams());
        profileResult.fold(
          (failure) {
            state = state.copyWith(loading: false, error: failure.message);
          },
          (profile) {
            state = state.copyWith(loading: false, profile: profile);
          },
        );
      },
    );
  }

  Future<void> deleteProfilePicture() async {
    state = state.copyWith(loading: true, error: null);
    final result = await _deleteProfilePicture(const NoParams());
    await result.fold(
      (failure) async {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (_) async {
        final profileResult = await _getUserProfile(const NoParams());
        profileResult.fold(
          (failure) {
            state = state.copyWith(loading: false, error: failure.message);
          },
          (profile) {
            state = state.copyWith(loading: false, profile: profile);
          },
        );
      },
    );
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(loading: true, error: null);
    final result = await _updateUserPassword(
      UpdateUserPasswordParams(currentPassword: currentPassword, newPassword: newPassword),
    );
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(loading: false);
      },
    );
  }
}

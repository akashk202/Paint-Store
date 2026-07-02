import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';

import '../../domain/usecases/fetch_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';

import 'checkout_state.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final FetchUserProfile fetchUserProfile;
  final UpdateUserProfile updateUserProfile;

  CheckoutNotifier({
    required this.fetchUserProfile,
    required this.updateUserProfile,
  }) : super(const CheckoutState()) {
    prefillFromAuthAndProfile();
  }

  Future<void> prefillFromAuthAndProfile() async {
    state = state.copyWith(loading: true, error: null);

    final result = await fetchUserProfile(const NoParams());
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (profile) {
        if (profile == null) {
          state = state.copyWith(loading: false);
          return;
        }

        state = state.copyWith(
          loading: false,
          name: profile.name,
          phone: profile.phone,
          email: profile.email,
          address: profile.address,
          lat: profile.lat,
          lng: profile.lng,
        );
      },
    );
  }

  void setLatLng(double? lat, double? lng) {
    state = state.copyWith(lat: lat, lng: lng);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  Future<void> saveProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
  }) async {
    state = state.copyWith(loading: true, error: null);
    final result = await updateUserProfile(
      UpdateUserProfileParams(
        fullName: fullName,
        phone: phone,
        email: email,
        address: address,
        lat: state.lat,
        lng: state.lng,
      ),
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

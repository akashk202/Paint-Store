import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/login_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/register_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/reset_password_usecase.dart';
import 'auth_providers.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is just 'not doing anything'
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
      ),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final googleSignInUseCase = ref.read(googleSignInUseCaseProvider);
    final result = await googleSignInUseCase(const NoParams());

    return result.fold(
      (failure) {
        // If Google sign-in was cancelled, we can handle it silently or set error
        if (failure.message == 'Google sign-in was cancelled') {
          state = const AsyncValue.data(null);
          return false;
        }
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> resetPassword(String email) async {
    state = const AsyncValue.loading();
    final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
    final result = await resetPasswordUseCase(
      ResetPasswordParams(email: email),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase(const NoParams());

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

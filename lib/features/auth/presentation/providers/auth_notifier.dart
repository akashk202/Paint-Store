import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/login_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/register_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:c_h_p/features/auth/domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
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
    state = state.copyWith(isLoading: true);
    final result = await _registerUseCase(
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
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);
    final result = await _googleSignInUseCase(const NoParams());

    return result.fold(
      (failure) {
        if (failure.message == 'Google sign-in was cancelled') {
          state = state.copyWith(isLoading: false);
          return false;
        }
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true);
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(email: email),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> logout() async {
    state = state.copyWith(isLoading: true);
    final result = await _logoutUseCase(const NoParams());

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }
}

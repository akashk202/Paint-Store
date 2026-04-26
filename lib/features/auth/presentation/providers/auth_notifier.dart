import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is just 'not doing anything'
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signInWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed. Please try again.";
      if (e.code == 'invalid-credential') {
        errorMessage = "Incorrect email or password. Please try again.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "This user account has been disabled.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address format is not valid.";
      } else {
        errorMessage = "An error occurred. Please check your connection.";
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncValue.error("An unexpected error occurred.", StackTrace.current);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.registerUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
      );
      state = const AsyncValue.data(null);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Registration failed", StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncValue.error("An unexpected error occurred: $e", StackTrace.current);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final cred = await repository.signInWithGoogle();
      if (cred == null) {
        state = const AsyncValue.data(null);
        return false; // User cancelled
      }
      state = const AsyncValue.data(null);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Google Sign-In failed", StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncValue.error("An unexpected error occurred during Google Sign-In.", StackTrace.current);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.resetPassword(email);
      state = const AsyncValue.data(null);
      return true; // Success
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncValue.error("An unexpected error occurred.", StackTrace.current);
      return false;
    }
  }
}

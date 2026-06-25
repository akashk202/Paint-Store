import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';

/// Abstract contract for authentication operations.
/// The data layer provides the implementation.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Create a new account with email and password.
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  });

  /// Sign in with Google.
  Future<Either<Failure, UserEntity>> googleSignIn();

  /// Send a password reset email.
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Sign out the current user.
  Future<Either<Failure, void>> logout();

  /// Get the currently authenticated user, or null.
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}

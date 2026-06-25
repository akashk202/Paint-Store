import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  });
  
  Future<Either<Failure, UserEntity>> googleSignIn();
  
  Future<Either<Failure, void>> resetPassword({required String email});
  
  Future<Either<Failure, void>> logout();

  Either<Failure, UserEntity?> getCurrentUser();
}


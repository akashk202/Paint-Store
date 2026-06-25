import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/exceptions.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(email: email, password: password);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    try {
      final userModel = await _remoteDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
      );
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> googleSignIn() async {
    try {
      final userModel = await _remoteDataSource.googleSignIn();
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<Failure, UserEntity?> getCurrentUser() {
    try {
      final userModel = _remoteDataSource.getCurrentUser();
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


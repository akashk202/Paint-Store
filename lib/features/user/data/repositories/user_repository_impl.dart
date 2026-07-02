import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      final profile = await remoteDataSource.getUserProfile();
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        name: name,
        phone: phone,
        address: address,
        pincode: pincode,
        lat: lat,
        lng: lng,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfilePicture(File imageFile) async {
    try {
      final url = await remoteDataSource.updateProfilePicture(imageFile);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePicture() async {
    try {
      await remoteDataSource.deleteProfilePicture();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserPassword(String currentPassword, String newPassword) async {
    try {
      await remoteDataSource.updateUserPassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> fetchUserRole(String uid) async {
    try {
      final role = await remoteDataSource.fetchUserRole(uid);
      return Right(role);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchPendingManagerRequests() async {
    try {
      final requests = await remoteDataSource.fetchPendingManagerRequests();
      return Right(requests);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveManagerRequest(String uid) async {
    try {
      await remoteDataSource.approveManagerRequest(uid);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> denyManagerRequest(String uid) async {
    try {
      await remoteDataSource.denyManagerRequest(uid);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Map<String, dynamic>> fetchAllUsersStream() {
    return remoteDataSource.fetchAllUsersStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value);
    });
  }

  @override
  Future<Either<Failure, void>> updateUserRole(String uid, String role) async {
    try {
      await remoteDataSource.updateUserRole(uid, role);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String uid) async {
    try {
      await remoteDataSource.deleteUser(uid);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

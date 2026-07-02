import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/checkout_profile.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';
import '../models/checkout_profile_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remote;

  CheckoutRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, CheckoutProfile?>> fetchUserProfile() async {
    try {
      final signedInUser = remote.fetchSignedInUserDetails();
      final profileMap = await remote.fetchUserProfile();

      if (profileMap == null &&
          signedInUser.values.every((value) => value.isEmpty)) {
        return const Right(null);
      }

      final profile = CheckoutProfileModel.fromRemote(
        signedInUser: signedInUser,
        profileMap: profileMap,
      );
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  }) async {
    try {
      await remote.updateUserProfile(
        fullName: fullName,
        phone: phone,
        email: email,
        address: address,
        lat: lat,
        lng: lng,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchCartItemNames() async {
    try {
      final names = await remote.fetchCartItemNames();
      return Right(names);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

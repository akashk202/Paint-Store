import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/checkout_profile.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, CheckoutProfile?>> fetchUserProfile();
  
  Future<Either<Failure, void>> updateUserProfile({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    double? lat,
    double? lng,
  });

  Future<Either<Failure, List<String>>> fetchCartItemNames();
}

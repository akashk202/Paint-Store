import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/checkout_profile.dart';
import '../repositories/checkout_repository.dart';

class FetchUserProfile implements UseCase<CheckoutProfile?, NoParams> {
  final CheckoutRepository repository;

  FetchUserProfile(this.repository);

  @override
  Future<Either<Failure, CheckoutProfile?>> call(NoParams params) {
    return repository.fetchUserProfile();
  }
}

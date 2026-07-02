import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfile implements UseCase<UserProfileEntity, NoParams> {
  final UserRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) {
    return repository.getUserProfile();
  }
}

import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';
import 'package:c_h_p/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.googleSignIn();
  }
}

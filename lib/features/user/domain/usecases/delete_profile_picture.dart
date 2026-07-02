import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class DeleteProfilePicture implements UseCase<void, NoParams> {
  final UserRepository repository;

  DeleteProfilePicture(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.deleteProfilePicture();
  }
}

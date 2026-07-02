import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class GetUserRole implements UseCase<String, String> {
  final UserRepository repository;

  GetUserRole(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) {
    return repository.fetchUserRole(params);
  }
}

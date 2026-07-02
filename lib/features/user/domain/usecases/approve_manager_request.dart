import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class ApproveManagerRequest implements UseCase<void, String> {
  final UserRepository repository;

  ApproveManagerRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.approveManagerRequest(params);
  }
}

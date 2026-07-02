import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class FetchPendingManagerRequests implements UseCase<List<Map<String, dynamic>>, NoParams> {
  final UserRepository repository;

  FetchPendingManagerRequests(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return repository.fetchPendingManagerRequests();
  }
}

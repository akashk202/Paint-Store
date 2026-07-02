import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class RemoveItem implements UseCase<void, String> {
  final CartRepository repository;

  RemoveItem(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.removeItem(params);
  }
}

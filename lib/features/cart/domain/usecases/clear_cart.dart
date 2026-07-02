import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ClearCart implements UseCase<void, NoParams> {
  final CartRepository repository;

  ClearCart(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearCart();
  }
}

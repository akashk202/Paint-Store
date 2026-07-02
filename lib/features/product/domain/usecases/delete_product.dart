import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProduct implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteProduct(params);
  }
}

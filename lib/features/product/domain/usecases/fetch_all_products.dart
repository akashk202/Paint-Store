import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class FetchAllProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  FetchAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.fetchAll();
  }
}

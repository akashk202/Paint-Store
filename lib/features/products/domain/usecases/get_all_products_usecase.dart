import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';
import 'package:c_h_p/features/products/domain/repositories/product_repository.dart';

class GetAllProductsUseCase
    extends UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) {
    return repository.getAllProducts();
  }
}

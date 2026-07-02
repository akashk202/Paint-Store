import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/color_catalogue_repository.dart';

class ResolveLinkedProduct implements UseCase<Product?, String> {
  final ColorCatalogueRepository repository;

  ResolveLinkedProduct(this.repository);

  @override
  Future<Either<Failure, Product?>> call(String params) {
    return repository.resolveLinkedProduct(params);
  }
}

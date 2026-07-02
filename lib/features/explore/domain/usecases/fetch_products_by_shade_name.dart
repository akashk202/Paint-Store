import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchProductsByShadeName implements UseCase<List<Product>, String> {
  final ColorCatalogueRepository repository;

  FetchProductsByShadeName(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String params) {
    return repository.fetchProductsByShadeName(params);
  }
}

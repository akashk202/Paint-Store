import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class SearchProducts implements UseCase<List<ExploreProductEntity>, String> {
  final ExploreRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(String params) {
    return repository.searchProducts(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetRecommendedProducts implements UseCase<List<ExploreProductEntity>, int> {
  final ExploreRepository repository;

  GetRecommendedProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(int params) {
    return repository.fetchRecommended(limit: params);
  }
}

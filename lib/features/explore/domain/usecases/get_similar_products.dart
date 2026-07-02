import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetSimilarProducts implements UseCase<List<ExploreProductEntity>, GetSimilarProductsParams> {
  final ExploreRepository repository;

  GetSimilarProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(GetSimilarProductsParams params) {
    return repository.fetchSimilarProducts(params.anchor, limit: params.limit);
  }
}

class GetSimilarProductsParams extends Equatable {
  final Product anchor;
  final int limit;

  const GetSimilarProductsParams({required this.anchor, this.limit = 10});

  @override
  List<Object?> get props => [anchor, limit];
}

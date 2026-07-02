import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetProductsByFilter implements UseCase<List<ExploreProductEntity>, GetProductsByFilterParams> {
  final ExploreRepository repository;

  GetProductsByFilter(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(GetProductsByFilterParams params) {
    return repository.fetchProductsByFilter(
      category: params.category,
      subCategory: params.subCategory,
      brand: params.brand,
    );
  }
}

class GetProductsByFilterParams extends Equatable {
  final String? category;
  final String? subCategory;
  final String? brand;

  const GetProductsByFilterParams({
    this.category,
    this.subCategory,
    this.brand,
  });

  @override
  List<Object?> get props => [category, subCategory, brand];
}

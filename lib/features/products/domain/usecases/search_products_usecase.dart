import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';
import 'package:c_h_p/features/products/domain/repositories/product_repository.dart';

class SearchProductsUseCase
    extends UseCase<List<ProductEntity>, SearchParams> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(SearchParams params) {
    return repository.searchProducts(params.query);
  }
}

class SearchParams extends Equatable {
  final String query;
  const SearchParams({required this.query});

  @override
  List<Object?> get props => [query];
}

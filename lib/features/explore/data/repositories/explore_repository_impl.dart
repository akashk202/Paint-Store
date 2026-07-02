import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../../product/data/models/product_model.dart';
import '../../domain/entities/explore_product_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> fetchSimilarProducts(Product anchor, {int limit = 10}) async {
    try {
      final result = await remoteDataSource.fetchSimilarProducts(anchor, limit: limit);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> fetchRecommended({int limit = 10}) async {
    try {
      final result = await remoteDataSource.fetchRecommended(limit: limit);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> searchProducts(String query) async {
    try {
      final result = await remoteDataSource.searchProducts(query);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> fetchProductsByFilter({
    String? category,
    String? subCategory,
    String? brand,
  }) async {
    try {
      final result = await remoteDataSource.fetchProductsByFilter(
        category: category,
        subCategory: subCategory,
        brand: brand,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/exceptions.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/products/data/datasources/product_remote_data_source.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';
import 'package:c_h_p/features/products/domain/repositories/product_repository.dart';

/// Concrete implementation of [ProductRepository].
/// Catches data-layer exceptions and returns [Either<Failure, T>].
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.fetchAllProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
      String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

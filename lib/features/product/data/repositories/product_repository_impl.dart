import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> fetchAll() async {
    try {
      final result = await _remoteDataSource.fetchAll();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(String key, Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.updateProduct(key, data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String key) async {
    try {
      await _remoteDataSource.deleteProduct(key);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Map<String, dynamic> data) async {
    try {
      await _remoteDataSource.addProduct(data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<Product>> productsStream() {
    return _remoteDataSource.productsStream().map((event) {
      if (event.snapshot.value == null) return [];
      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Product> products = [];
      map.forEach((key, value) {
        try {
          products.add(ProductModel.fromMap(key, Map<String, dynamic>.from(value)));
        } catch (_) {}
      });
      return products;
    });
  }
}

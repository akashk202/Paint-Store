import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_remote_datasource.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;

  StockRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Product>> watchStock() {
    return remoteDataSource.watchStock();
  }

  @override
  Future<Either<Failure, void>> updateStock(String productKey, int newStock) async {
    try {
      await remoteDataSource.updateStock(productKey, newStock);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:c_h_p/features/product/data/models/product_model.dart';import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_remote_datasource.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;

  StockRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Product>> watchStock() {
    return remoteDataSource.watchStock();
  }

  @override
  Future<void> updateStock(String productKey, int newStock) {
    return remoteDataSource.updateStock(productKey, newStock);
  }
}

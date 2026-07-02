import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/stock_repository.dart';

class WatchStock {
  final StockRepository repository;

  WatchStock(this.repository);

  Stream<List<Product>> call() {
    return repository.watchStock();
  }
}

class UpdateStock {
  final StockRepository repository;

  UpdateStock(this.repository);

  Future<void> call(String productKey, int newStock) {
    return repository.updateStock(productKey, newStock);
  }
}


// implements UseCase

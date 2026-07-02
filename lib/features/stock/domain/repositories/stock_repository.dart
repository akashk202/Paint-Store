import 'package:c_h_p/features/product/domain/entities/product_entity.dart';

abstract class StockRepository {
  Stream<List<Product>> watchStock();
  Future<void> updateStock(String productKey, int newStock);
}


// Either<Failure, T>

import 'package:c_h_p/features/product/data/models/product_model.dart';abstract class StockRepository {
  Stream<List<Product>> watchStock();
  Future<void> updateStock(String productKey, int newStock);
}

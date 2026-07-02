import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';

abstract class StockRepository {
  Stream<List<Product>> watchStock();
  Future<Either<Failure, void>> updateStock(String productKey, int newStock);
}

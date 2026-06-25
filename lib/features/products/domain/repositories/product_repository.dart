import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';

/// Abstract contract for product data operations.
abstract class ProductRepository {
  /// Fetch all products from the data source.
  Future<Either<Failure, List<ProductEntity>>> getAllProducts();

  /// Search products by query string (name match).
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
}

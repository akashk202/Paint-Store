import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> fetchAll();
  Future<Either<Failure, void>> updateProduct(String key, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteProduct(String key);
  Future<Either<Failure, void>> addProduct(Map<String, dynamic> data);
  Stream<List<Product>> productsStream();
}

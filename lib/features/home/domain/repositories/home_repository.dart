import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/home_product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeProductEntity>>> fetchAllProducts();

  Stream<int> unreadCountStream(String uid);
}

import '../entities/home_product_entity.dart';

abstract class HomeRepository {
  Future<List<HomeProductEntity>> fetchAllProducts();

  Stream<int> unreadCountStream(String uid);
}


// Either<Failure, T>

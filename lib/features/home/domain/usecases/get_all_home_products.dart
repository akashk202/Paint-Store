import '../entities/home_product_entity.dart';
import '../repositories/home_repository.dart';

class GetAllHomeProducts {
  final HomeRepository repository;

  GetAllHomeProducts(this.repository);

  Future<List<HomeProductEntity>> call() {
    return repository.fetchAllProducts();
  }
}

import '../../data/models/product_model.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.addProduct(data);
  }
}

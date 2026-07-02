import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsStream implements StreamUseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsStream(this.repository);

  @override
  Stream<List<Product>> call(NoParams params) {
    return repository.productsStream();
  }
}

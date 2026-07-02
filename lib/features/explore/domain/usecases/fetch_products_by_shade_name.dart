import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchProductsByShadeName {
  final ColorCatalogueRepository repository;

  FetchProductsByShadeName(this.repository);

  Future<List<Product>> call(String shadeName) {
    return repository.fetchProductsByShadeName(shadeName);
  }
}


// implements UseCase

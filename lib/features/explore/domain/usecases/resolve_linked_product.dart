import 'package:c_h_p/features/product/data/models/product_model.dart';
import '../repositories/color_catalogue_repository.dart';

class ResolveLinkedProduct {
  final ColorCatalogueRepository repository;

  ResolveLinkedProduct(this.repository);

  Future<Product?> call(String shadeCode) {
    return repository.resolveLinkedProduct(shadeCode);
  }
}

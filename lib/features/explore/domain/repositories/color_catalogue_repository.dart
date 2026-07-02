import '../entities/color_shade.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';

abstract class ColorCatalogueRepository {
  Future<List<ColorShade>> fetchAllShades();
  Future<Product?> resolveLinkedProduct(String shadeCode);
  Future<List<Product>> fetchProductsByShadeName(String shadeName);
  Stream<Map<String, dynamic>> latestColorsStream();
  Stream<Map<String, dynamic>> colorCategoriesStream();
  Future<Map<String, dynamic>?> fetchShadeLink(String shadeCode);
  Future<void> setShadeLink(String shadeCode, Map<String, dynamic> data);
  Future<void> removeShadeLink(String shadeCode);
}


// Either<Failure, T>

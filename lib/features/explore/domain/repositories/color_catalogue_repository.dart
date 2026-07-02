import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/color_shade.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';

abstract class ColorCatalogueRepository {
  Future<Either<Failure, List<ColorShade>>> fetchAllShades();
  Future<Either<Failure, Product?>> resolveLinkedProduct(String shadeCode);
  Future<Either<Failure, List<Product>>> fetchProductsByShadeName(String shadeName);
  Stream<Map<String, dynamic>> latestColorsStream();
  Stream<Map<String, dynamic>> colorCategoriesStream();
  Future<Either<Failure, Map<String, dynamic>?>> fetchShadeLink(String shadeCode);
  Future<Either<Failure, void>> setShadeLink(String shadeCode, Map<String, dynamic> data);
  Future<Either<Failure, void>> removeShadeLink(String shadeCode);
}

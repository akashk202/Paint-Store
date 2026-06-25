import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/color_shade.dart';
import '../../domain/repositories/color_catalogue_repository.dart';
import '../datasources/color_catalogue_remote_datasource.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';

class ColorCatalogueRepositoryImpl implements ColorCatalogueRepository {
  final ColorCatalogueRemoteDataSource remoteDataSource;

  ColorCatalogueRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ColorShade>> fetchAllShades() {
    return remoteDataSource.fetchAllShades();
  }

  @override
  Future<Product?> resolveLinkedProduct(String shadeCode) {
    return remoteDataSource.resolveLinkedProduct(shadeCode);
  }

  @override
  Future<List<Product>> fetchProductsByShadeName(String shadeName) {
    return remoteDataSource.fetchProductsByShadeName(shadeName);
  }

  @override
  Stream<Map<String, dynamic>> latestColorsStream() {
    return remoteDataSource.latestColorsStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value as Map);
    });
  }

  @override
  Stream<Map<String, dynamic>> colorCategoriesStream() {
    return remoteDataSource.colorCategoriesStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value as Map);
    });
  }

  @override
  Future<Map<String, dynamic>?> fetchShadeLink(String shadeCode) {
    return remoteDataSource.fetchShadeLink(shadeCode);
  }

  @override
  Future<void> setShadeLink(String shadeCode, Map<String, dynamic> data) {
    return remoteDataSource.setShadeLink(shadeCode, data);
  }

  @override
  Future<void> removeShadeLink(String shadeCode) {
    return remoteDataSource.removeShadeLink(shadeCode);
  }
}

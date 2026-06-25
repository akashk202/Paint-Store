import 'package:firebase_database/firebase_database.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';

/// Data source for color catalogue operations.
/// All Firebase access for color shades, shade links, and shade-product
/// lookups is centralised here.
abstract class ColorCatalogueRemoteDataSource {
  /// Fetch all color categories with their shades.
  Future<List<ColorShadeModel>> fetchAllShades();

  /// Given a shade code, resolve a linked product (if any).
  Future<Product?> resolveLinkedProduct(String shadeCode);

  /// Fetch products whose shadeName matches.
  Future<List<Product>> fetchProductsByShadeName(String shadeName);

  /// Stream of latest colors ordered by timestamp.
  Stream<DatabaseEvent> latestColorsStream();

  /// Stream of all color categories (for shade picker UI).
  Stream<DatabaseEvent> colorCategoriesStream();

  /// Fetch existing shade link for a shade code.
  Future<Map<String, dynamic>?> fetchShadeLink(String shadeCode);

  /// Create or replace a shade link.
  Future<void> setShadeLink(String shadeCode, Map<String, dynamic> data);

  /// Remove a shade link.
  Future<void> removeShadeLink(String shadeCode);
}

class ColorCatalogueRemoteDataSourceImpl
    implements ColorCatalogueRemoteDataSource {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  Future<List<ColorShadeModel>> fetchAllShades() async {
    final snapshot = await _dbRef.child('colorCategories').get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final List<ColorShadeModel> shades = [];

    data.forEach((categoryKey, shadesData) {
      final ck = categoryKey.toString();
      final categoryName =
          ck.isNotEmpty ? ck[0].toUpperCase() + ck.substring(1) : ck;
      if (shadesData is Map) {
        final familyShadesMap = Map<String, dynamic>.from(shadesData);
        familyShadesMap.forEach((shadeCode, shadeDetails) {
          if (shadeDetails is Map) {
            final shade = Map<String, dynamic>.from(shadeDetails);
            shades.add(ColorShadeModel(
              category: categoryName,
              code: shadeCode.toString(),
              name: shade['name']?.toString() ?? 'Unnamed',
              hex: shade['hex']?.toString() ?? '#FFFFFF',
            ));
          }
        });
      }
    });

    return shades;
  }

  @override
  Future<Product?> resolveLinkedProduct(String shadeCode) async {
    if (shadeCode.isEmpty) return null;
    try {
      final linkSnap = await _dbRef.child('shadeLinks/$shadeCode').get();
      if (!linkSnap.exists || linkSnap.value is! Map) return null;

      final link = Map<String, dynamic>.from(linkSnap.value as Map);
      final String? productId = link['productId']?.toString();
      if (productId == null || productId.isEmpty) return null;

      final prodSnap = await _dbRef.child('products/$productId').get();
      if (!prodSnap.exists || prodSnap.value is! Map) return null;

      return Product.fromMap(
          productId, Map<String, dynamic>.from(prodSnap.value as Map));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> fetchProductsByShadeName(String shadeName) async {
    final snapshot = await _dbRef
        .child('products')
        .orderByChild('shadeName')
        .equalTo(shadeName)
        .get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final productsMap = Map<String, dynamic>.from(snapshot.value as Map);
    final List<Product> products = [];
    productsMap.forEach((key, value) {
      try {
        products.add(Product.fromMap(key, Map<String, dynamic>.from(value)));
      } catch (_) {}
    });
    return products;
  }

  @override
  Stream<DatabaseEvent> latestColorsStream() {
    return _dbRef.child('latestColors').orderByChild('timestamp').onValue;
  }

  @override
  Stream<DatabaseEvent> colorCategoriesStream() {
    return _dbRef.child('colorCategories').onValue;
  }

  @override
  Future<Map<String, dynamic>?> fetchShadeLink(String shadeCode) async {
    if (shadeCode.isEmpty) return null;
    try {
      final snap = await _dbRef.child('shadeLinks/$shadeCode').get();
      if (snap.exists && snap.value is Map) {
        return Map<String, dynamic>.from(snap.value as Map);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> setShadeLink(String shadeCode, Map<String, dynamic> data) async {
    await _dbRef.child('shadeLinks/$shadeCode').set(data);
  }

  @override
  Future<void> removeShadeLink(String shadeCode) async {
    await _dbRef.child('shadeLinks/$shadeCode').remove();
  }
}

/// Simple model for a color shade entry.
class ColorShadeModel {
  final String category;
  final String code;
  final String name;
  final String hex;

  const ColorShadeModel({
    required this.category,
    required this.code,
    required this.name,
    required this.hex,
  });

  Map<String, String> toMap() => {
        'category': category,
        'code': code,
        'name': name,
        'hex': hex,
      };
}

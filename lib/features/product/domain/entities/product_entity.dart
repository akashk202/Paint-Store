// Pure domain entity for a Product.
// Contains only business-relevant fields — no serialization logic.

/// Value object for a clickable benefit.
class Benefit {
  final String image;
  final String text;

  const Benefit({required this.image, required this.text});
}

/// Value object for a pack size variant.
class PackSize {
  final String size;
  final String price;

  const PackSize({required this.size, required this.price});

  /// Helper to get the numeric part of the size for sorting.
  double get numericSize {
    final first = size.split(' ').first;
    final cleaned = first.replaceAll(RegExp('[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}

/// The main Product domain entity.
class Product {
  final String key;
  final String name;
  final String description;
  final int stock;
  final String? brand;
  final String? category;
  final String? subCategory;
  final String mainImageUrl;
  final String backgroundImageUrl;
  final List<Benefit> benefits;
  final List<PackSize> packSizes;
  final String brochureUrl;
  final int? warrantyYears;

  const Product({
    required this.key,
    required this.name,
    required this.description,
    required this.stock,
    this.brand,
    this.category,
    this.subCategory,
    required this.mainImageUrl,
    required this.backgroundImageUrl,
    required this.benefits,
    required this.packSizes,
    required this.brochureUrl,
    this.warrantyYears,
  });
}

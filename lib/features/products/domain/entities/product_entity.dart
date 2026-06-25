import 'package:equatable/equatable.dart';

/// Pure domain entity for a pack size option.
class PackSizeEntity extends Equatable {
  final String size;
  final String price;

  const PackSizeEntity({required this.size, required this.price});

  double get numericSize {
    final first = size.split(' ').first;
    final cleaned = first.replaceAll(RegExp('[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  List<Object?> get props => [size, price];
}

/// Pure domain entity for a product benefit.
class BenefitEntity extends Equatable {
  final String image;
  final String text;

  const BenefitEntity({required this.image, required this.text});

  @override
  List<Object?> get props => [image, text];
}

/// Pure domain entity representing a product.
/// No Firebase or serialization logic here.
class ProductEntity extends Equatable {
  final String key;
  final String name;
  final String description;
  final int stock;
  final String? brand;
  final String? category;
  final String? subCategory;
  final String mainImageUrl;
  final String backgroundImageUrl;
  final List<BenefitEntity> benefits;
  final List<PackSizeEntity> packSizes;
  final String brochureUrl;
  final int? warrantyYears;

  const ProductEntity({
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

  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 5;

  @override
  List<Object?> get props => [key, name, stock, brand, category];
}

import 'package:c_h_p/features/products/domain/entities/product_entity.dart';

/// Data model for product benefits with Firebase serialization.
class BenefitModel extends BenefitEntity {
  const BenefitModel({required super.image, required super.text});

  factory BenefitModel.fromMap(Map<String, dynamic> map) {
    return BenefitModel(
      image: map['image'] ?? '',
      text: map['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'image': image, 'text': text};
}

/// Data model for pack sizes with Firebase serialization.
class PackSizeModel extends PackSizeEntity {
  const PackSizeModel({required super.size, required super.price});

  factory PackSizeModel.fromMap(String size, dynamic price) {
    return PackSizeModel(size: size, price: price?.toString() ?? '0');
  }

  Map<String, dynamic> toMap() => {'size': size, 'price': price};
}

/// Data model that extends [ProductEntity] with Firebase serialization.
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.key,
    required super.name,
    required super.description,
    required super.stock,
    super.brand,
    super.category,
    super.subCategory,
    required super.mainImageUrl,
    required super.backgroundImageUrl,
    required super.benefits,
    required super.packSizes,
    required super.brochureUrl,
    super.warrantyYears,
  });

  /// Create from a Firebase Realtime Database snapshot.
  factory ProductModel.fromMap(String key, Map<String, dynamic> map) {
    // Parse benefits
    var benefitList = <BenefitModel>[];
    if (map['benefits'] is List) {
      for (var item in (map['benefits'] as List)) {
        if (item is Map) {
          benefitList
              .add(BenefitModel.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    // Parse pack sizes (handles multiple Firebase data shapes)
    var packSizeList = <PackSizeModel>[];
    final rawPack =
        map['packSizes'] ?? map['pack_sizes'] ?? map['sizes'] ?? map['variants'];
    if (rawPack is Map) {
      rawPack.forEach((size, price) {
        packSizeList.add(PackSizeModel.fromMap(size.toString(), price));
      });
    } else if (rawPack is List) {
      for (final item in rawPack) {
        if (item is Map) {
          final i = Map<String, dynamic>.from(item);
          final size =
              (i['size'] ?? i['pack'] ?? i['label'] ?? '').toString();
          final price = i['price'] ?? i['mrp'] ?? i['amount'];
          if (size.isNotEmpty) {
            packSizeList.add(PackSizeModel.fromMap(size, price));
          }
        }
      }
    }
    if (packSizeList.isNotEmpty) {
      packSizeList.sort((a, b) => a.numericSize.compareTo(b.numericSize));
    }

    return ProductModel(
      key: key,
      name: map['name'] ?? 'No Name',
      description: map['description'] ?? 'No Description',
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      brand: map['brand'],
      category: map['category'],
      subCategory: map['subCategory'],
      mainImageUrl: map['mainImageUrl'] ?? map['imageUrl'] ?? '',
      backgroundImageUrl: map['backgroundImageUrl'] ?? '',
      benefits: benefitList,
      packSizes: packSizeList,
      brochureUrl: map['brochureUrl'] ?? '',
      warrantyYears: (map['warrantyYears'] as num?)?.toInt(),
    );
  }

  /// Convert to a map for Firebase Realtime Database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stock': stock,
      'brand': brand,
      'category': category,
      'subCategory': subCategory,
      'mainImageUrl': mainImageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'benefits': benefits
          .map((b) => {'image': b.image, 'text': b.text})
          .toList(),
      'packSizes': {
        for (final ps in packSizes) ps.size: ps.price,
      },
      'brochureUrl': brochureUrl,
      'warrantyYears': warrantyYears,
    };
  }
}

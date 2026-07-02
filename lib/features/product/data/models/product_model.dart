import '../../../product/domain/entities/product_entity.dart';
export '../../../product/domain/entities/product_entity.dart' show Benefit, PackSize, Product;

/// Data-layer model that adds Firebase/JSON serialisation on top of the
/// domain [Product] entity.
///
/// We re-export [Product], [Benefit] and [PackSize] from the entity file so
/// that existing call-sites that import this file continue to compile without
/// changes during the migration.
class ProductModel extends Product {
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

  factory ProductModel.fromMap(String key, Map<String, dynamic> map) {
    var benefitList = <Benefit>[];
    if (map['benefits'] is List) {
      for (var item in (map['benefits'] as List)) {
        if (item is Map) {
          final m = Map<String, dynamic>.from(item);
          benefitList.add(Benefit(image: m['image'] ?? '', text: m['text'] ?? ''));
        }
      }
    }

    var packSizeList = <PackSize>[];
    final rawPack = map['packSizes'] ?? map['pack_sizes'] ?? map['sizes'] ?? map['variants'];
    if (rawPack is Map) {
      rawPack.forEach((size, price) {
        packSizeList.add(PackSize(size: size.toString(), price: price?.toString() ?? '0'));
      });
    } else if (rawPack is List) {
      for (final item in rawPack) {
        if (item is Map) {
          final i = Map<String, dynamic>.from(item);
          final size = (i['size'] ?? i['pack'] ?? i['label'] ?? '').toString();
          final price = i['price'] ?? i['mrp'] ?? i['amount'];
          if (size.isNotEmpty) {
            packSizeList.add(PackSize(size: size, price: price?.toString() ?? '0'));
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
      warrantyYears: map['warrantyYears'] is int
          ? map['warrantyYears']
          : int.tryParse(map['warrantyYears']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stock': stock,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (subCategory != null) 'subCategory': subCategory,
      'mainImageUrl': mainImageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'benefits': benefits.map((b) => {'image': b.image, 'text': b.text}).toList(),
      'packSizes': Map.fromEntries(packSizes.map((p) => MapEntry(p.size, p.price))),
      'brochureUrl': brochureUrl,
      if (warrantyYears != null) 'warrantyYears': warrantyYears,
    };
  }
}
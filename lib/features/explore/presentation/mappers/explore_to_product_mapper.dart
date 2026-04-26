import 'package:c_h_p/features/product/data/models/product_model.dart';
import '../../domain/entities/explore_product_entity.dart';

/// Presentation-layer mapper: converts an [ExploreProductEntity] (domain)
/// into a [Product] (product-feature model) for cross-feature navigation
/// and cart operations.
///
/// This keeps the data-layer import out of page widgets.
Product exploreEntityToProduct(ExploreProductEntity entity) {
  return Product(
    key: entity.key,
    name: entity.name,
    description: entity.description,
    stock: entity.stock,
    brand: entity.brand,
    category: entity.category,
    subCategory: entity.subCategory,
    mainImageUrl: entity.mainImageUrl,
    backgroundImageUrl: entity.backgroundImageUrl,
    benefits: entity.benefits
        .map((b) => Benefit(image: b.image, text: b.text))
        .toList(),
    packSizes: entity.packSizes
        .map((p) => PackSize(size: p.size, price: p.price))
        .toList(),
    brochureUrl: entity.brochureUrl,
    warrantyYears: entity.warrantyYears,
  );
}

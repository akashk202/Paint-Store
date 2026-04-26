import 'package:c_h_p/features/product/data/models/product_model.dart';import '../../domain/entities/home_product_entity.dart';

class HomeProductModel extends HomeProductEntity {
  const HomeProductModel({
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

  factory HomeProductModel.fromProduct(Product product) {
    return HomeProductModel(
      key: product.key,
      name: product.name,
      description: product.description,
      stock: product.stock,
      brand: product.brand,
      category: product.category,
      subCategory: product.subCategory,
      mainImageUrl: product.mainImageUrl,
      backgroundImageUrl: product.backgroundImageUrl,
      benefits: product.benefits
          .map(
            (benefit) => HomeBenefitEntity(
              image: benefit.image,
              text: benefit.text,
            ),
          )
          .toList(),
      packSizes: product.packSizes
          .map(
            (pack) => HomePackSizeEntity(
              size: pack.size,
              price: pack.price,
            ),
          )
          .toList(),
      brochureUrl: product.brochureUrl,
      warrantyYears: product.warrantyYears,
    );
  }

  factory HomeProductModel.fromEntity(HomeProductEntity entity) {
    return HomeProductModel(
      key: entity.key,
      name: entity.name,
      description: entity.description,
      stock: entity.stock,
      brand: entity.brand,
      category: entity.category,
      subCategory: entity.subCategory,
      mainImageUrl: entity.mainImageUrl,
      backgroundImageUrl: entity.backgroundImageUrl,
      benefits: entity.benefits,
      packSizes: entity.packSizes,
      brochureUrl: entity.brochureUrl,
      warrantyYears: entity.warrantyYears,
    );
  }

  Product toProduct() {
    return Product(
      key: key,
      name: name,
      description: description,
      stock: stock,
      brand: brand,
      category: category,
      subCategory: subCategory,
      mainImageUrl: mainImageUrl,
      backgroundImageUrl: backgroundImageUrl,
      benefits: benefits
          .map((benefit) => Benefit(image: benefit.image, text: benefit.text))
          .toList(),
      packSizes: packSizes
          .map((pack) => PackSize(size: pack.size, price: pack.price))
          .toList(),
      brochureUrl: brochureUrl,
      warrantyYears: warrantyYears,
    );
  }
}

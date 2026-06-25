class ExploreBenefitEntity {
  final String image;
  final String text;

  const ExploreBenefitEntity({
    required this.image,
    required this.text,
  });
}

class ExplorePackSizeEntity {
  final String size;
  final String price;

  const ExplorePackSizeEntity({
    required this.size,
    required this.price,
  });
}

class ExploreProductEntity {
  final String key;
  final String name;
  final String description;
  final int stock;
  final String? brand;
  final String? category;
  final String? subCategory;
  final String mainImageUrl;
  final String backgroundImageUrl;
  final List<ExploreBenefitEntity> benefits;
  final List<ExplorePackSizeEntity> packSizes;
  final String brochureUrl;
  final int? warrantyYears;

  const ExploreProductEntity({
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

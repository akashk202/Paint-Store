class HomeBenefitEntity {
  final String image;
  final String text;

  const HomeBenefitEntity({
    required this.image,
    required this.text,
  });
}

class HomePackSizeEntity {
  final String size;
  final String price;

  const HomePackSizeEntity({
    required this.size,
    required this.price,
  });
}

class HomeProductEntity {
  final String key;
  final String name;
  final String description;
  final int stock;
  final String? brand;
  final String? category;
  final String? subCategory;
  final String mainImageUrl;
  final String backgroundImageUrl;
  final List<HomeBenefitEntity> benefits;
  final List<HomePackSizeEntity> packSizes;
  final String brochureUrl;
  final int? warrantyYears;

  const HomeProductEntity({
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

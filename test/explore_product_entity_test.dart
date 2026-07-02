import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/explore/domain/entities/explore_product_entity.dart';

void main() {
  group('ExploreProductEntity Tests', () {
    test('should create ExploreProductEntity with correct values', () {
      const entity = ExploreProductEntity(
        key: 'prod_key',
        name: 'Paint Blue',
        description: 'Descr',
        stock: 5,
        brand: 'Asian Paints',
        category: 'Interior',
        subCategory: 'Wall Paint',
        mainImageUrl: 'img_url',
        backgroundImageUrl: 'bg_url',
        benefits: [],
        packSizes: [],
        brochureUrl: 'brochure_url',
        warrantyYears: 3,
      );
      expect(entity.key, 'prod_key');
      expect(entity.name, 'Paint Blue');
      expect(entity.description, 'Descr');
      expect(entity.stock, 5);
      expect(entity.brand, 'Asian Paints');
      expect(entity.category, 'Interior');
      expect(entity.subCategory, 'Wall Paint');
      expect(entity.mainImageUrl, 'img_url');
      expect(entity.backgroundImageUrl, 'bg_url');
      expect(entity.benefits, isEmpty);
      expect(entity.packSizes, isEmpty);
      expect(entity.brochureUrl, 'brochure_url');
      expect(entity.warrantyYears, 3);
    });
  });
}

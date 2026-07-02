import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/home/domain/entities/home_product_entity.dart';

void main() {
  group('HomeProductEntity Tests', () {
    test('should create HomeProductEntity with correct values', () {
      const entity = HomeProductEntity(
        key: 'key1',
        name: 'Red Paint',
        description: 'Descr',
        stock: 10,
        brand: 'Indigo',
        category: 'Exterior',
        subCategory: 'Wall Paint',
        mainImageUrl: 'url1',
        backgroundImageUrl: 'url2',
        benefits: [],
        packSizes: [],
        brochureUrl: 'brochure_url',
        warrantyYears: 5,
      );
      expect(entity.key, 'key1');
      expect(entity.name, 'Red Paint');
      expect(entity.description, 'Descr');
      expect(entity.stock, 10);
      expect(entity.brand, 'Indigo');
      expect(entity.category, 'Exterior');
      expect(entity.subCategory, 'Wall Paint');
      expect(entity.mainImageUrl, 'url1');
      expect(entity.backgroundImageUrl, 'url2');
      expect(entity.benefits, isEmpty);
      expect(entity.packSizes, isEmpty);
      expect(entity.brochureUrl, 'brochure_url');
      expect(entity.warrantyYears, 5);
    });
  });
}

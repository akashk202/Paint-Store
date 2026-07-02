import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity Tests', () {
    test('should create Product with correct values', () {
      const entity = Product(
        key: 'k',
        name: 'N',
        description: 'D',
        stock: 5,
        mainImageUrl: 'm',
        backgroundImageUrl: 'b',
        benefits: [],
        packSizes: [],
        brochureUrl: 'br',
      );
      expect(entity.key, 'k');
      expect(entity.name, 'N');
      expect(entity.description, 'D');
      expect(entity.stock, 5);
    });
  });
}

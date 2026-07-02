import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/cart/domain/entities/cart_item.dart';

void main() {
  group('CartItem Tests', () {
    test('should create CartItem with correct values', () {
      final item = CartItem(
        productKey: 'prod1',
        name: 'Paint 1',
        imageUrl: 'http://example.com/image.png',
        size: '1L',
        price: '100',
        quantity: 2,
      );
      expect(item.productKey, 'prod1');
      expect(item.name, 'Paint 1');
      expect(item.imageUrl, 'http://example.com/image.png');
      expect(item.size, '1L');
      expect(item.price, '100');
      expect(item.quantity, 2);
    });
  });
}

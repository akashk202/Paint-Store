import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/explore/domain/entities/color_shade.dart';

void main() {
  group('ColorShade Tests', () {
    test('should create ColorShade with correct values', () {
      const shade = ColorShade(
        category: 'Interior',
        code: 'W101',
        name: 'Creamy White',
        hex: '#FDFBF7',
      );
      expect(shade.category, 'Interior');
      expect(shade.code, 'W101');
      expect(shade.name, 'Creamy White');
      expect(shade.hex, '#FDFBF7');
    });
  });
}

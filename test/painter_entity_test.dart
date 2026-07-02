import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/painters/domain/entities/painter_entity.dart';

void main() {
  group('PainterEntity Tests', () {
    test('should create Painter with correct values', () {
      const entity = Painter(
        key: 'p_key',
        name: 'Painter 1',
        location: 'Loc',
        dailyFare: 200,
      );
      expect(entity.key, 'p_key');
      expect(entity.name, 'Painter 1');
      expect(entity.location, 'Loc');
      expect(entity.dailyFare, 200);
    });
  });
}

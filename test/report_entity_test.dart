import 'package:flutter_test/flutter_test.dart';
import 'package:c_h_p/features/report/domain/entities/report_entity.dart';

void main() {
  group('ReportEntity Tests', () {
    test('should create ReportEntity with correct values', () {
      final entity = ReportEntity(
        key: 'rep_key',
        userId: 'user_123',
        name: 'Tester',
        email: 'test@example.com',
        issue: 'Broken button',
        timestamp: 1600000000,
        status: 'pending',
      );
      expect(entity.key, 'rep_key');
      expect(entity.userId, 'user_123');
      expect(entity.name, 'Tester');
      expect(entity.email, 'test@example.com');
      expect(entity.issue, 'Broken button');
      expect(entity.timestamp, 1600000000);
      expect(entity.status, 'pending');
    });
  });
}

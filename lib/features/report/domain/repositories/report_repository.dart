import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<void> submitIssue(String issueText);
  Stream<List<ReportEntity>> watchReports();
  Future<void> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  });
}

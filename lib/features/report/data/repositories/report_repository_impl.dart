import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitIssue(String issueText) {
    return remoteDataSource.submitIssue(issueText);
  }

  @override
  Stream<List<ReportEntity>> watchReports() {
    return remoteDataSource.watchReports();
  }

  @override
  Future<void> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  }) {
    return remoteDataSource.resolveReport(
      reportKey: reportKey,
      userId: userId,
      issueText: issueText,
    );
  }
}

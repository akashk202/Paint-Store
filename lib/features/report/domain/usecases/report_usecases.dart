import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class SubmitReport {
  final ReportRepository repository;

  SubmitReport(this.repository);

  Future<void> call(String issueText) {
    return repository.submitIssue(issueText);
  }
}

class WatchReports {
  final ReportRepository repository;

  WatchReports(this.repository);

  Stream<List<ReportEntity>> call() {
    return repository.watchReports();
  }
}

class ResolveReport {
  final ReportRepository repository;

  ResolveReport(this.repository);

  Future<void> call({
    required String reportKey,
    required String userId,
    required String issueText,
  }) {
    return repository.resolveReport(
      reportKey: reportKey,
      userId: userId,
      issueText: issueText,
    );
  }
}


// implements UseCase

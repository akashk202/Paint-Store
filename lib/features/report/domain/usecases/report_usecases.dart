import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class SubmitReport implements UseCase<void, String> {
  final ReportRepository repository;

  SubmitReport(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.submitIssue(params);
  }
}

class WatchReports implements StreamUseCase<List<ReportEntity>, NoParams> {
  final ReportRepository repository;

  WatchReports(this.repository);

  @override
  Stream<List<ReportEntity>> call(NoParams params) {
    return repository.watchReports();
  }
}

class ResolveReport implements UseCase<void, ResolveReportParams> {
  final ReportRepository repository;

  ResolveReport(this.repository);

  @override
  Future<Either<Failure, void>> call(ResolveReportParams params) {
    return repository.resolveReport(
      reportKey: params.reportKey,
      userId: params.userId,
      issueText: params.issueText,
    );
  }
}

class ResolveReportParams extends Equatable {
  final String reportKey;
  final String userId;
  final String issueText;

  const ResolveReportParams({
    required this.reportKey,
    required this.userId,
    required this.issueText,
  });

  @override
  List<Object?> get props => [reportKey, userId, issueText];
}

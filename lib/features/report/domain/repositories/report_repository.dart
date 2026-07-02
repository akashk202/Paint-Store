import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> submitIssue(String issueText);
  Stream<List<ReportEntity>> watchReports();
  Future<Either<Failure, void>> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  });
}

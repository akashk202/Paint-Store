import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> submitIssue(String issueText) async {
    try {
      await remoteDataSource.submitIssue(issueText);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ReportEntity>> watchReports() {
    return remoteDataSource.watchReports();
  }

  @override
  Future<Either<Failure, void>> resolveReport({
    required String reportKey,
    required String userId,
    required String issueText,
  }) async {
    try {
      await remoteDataSource.resolveReport(
        reportKey: reportKey,
        userId: userId,
        issueText: issueText,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

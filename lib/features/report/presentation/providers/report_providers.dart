import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../data/datasources/report_remote_datasource.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/usecases/report_usecases.dart';
import 'report_notifier.dart';

final _reportRemoteDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSourceImpl(
    dbRef: FirebaseDatabase.instance.ref(),
    auth: FirebaseAuth.instance,
  );
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.read(_reportRemoteDataSourceProvider));
});

final submitReportUseCaseProvider = Provider<SubmitReport>((ref) {
  return SubmitReport(ref.read(reportRepositoryProvider));
});

final watchReportsUseCaseProvider = Provider<WatchReports>((ref) {
  return WatchReports(ref.read(reportRepositoryProvider));
});

final resolveReportUseCaseProvider = Provider<ResolveReport>((ref) {
  return ResolveReport(ref.read(reportRepositoryProvider));
});

final reportNotifierProvider =
    StateNotifierProvider<ReportNotifier, ReportState>((ref) {
  return ReportNotifier(
    submitReport: ref.read(submitReportUseCaseProvider),
    watchReports: ref.read(watchReportsUseCaseProvider),
    resolveReport: ref.read(resolveReportUseCaseProvider),
  );
});

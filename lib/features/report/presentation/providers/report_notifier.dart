import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';

import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/report_usecases.dart';

class ReportState {
  final bool submitting;
  final Object? error;
  const ReportState({this.submitting = false, this.error});

  ReportState copyWith({bool? submitting, Object? error}) {
    return ReportState(
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }
}

class ReportNotifier extends StateNotifier<ReportState> {
  final SubmitReport _submitReport;
  final WatchReports _watchReports;
  final ResolveReport _resolveReport;

  ReportNotifier({
    required SubmitReport submitReport,
    required WatchReports watchReports,
    required ResolveReport resolveReport,
  })  : _submitReport = submitReport,
        _watchReports = watchReports,
        _resolveReport = resolveReport,
        super(const ReportState());

  Future<void> submitIssue(String issueText) async {
    state = state.copyWith(submitting: true, error: null);
    final result = await _submitReport(issueText);
    result.fold(
      (failure) {
        state = state.copyWith(submitting: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(submitting: false);
      },
    );
  }

  Stream<List<ReportEntity>> reportsStream() {
    return _watchReports(const NoParams());
  }

  Future<void> resolve({
    required String reportKey,
    required String userId,
    required String issueText,
  }) async {
    state = state.copyWith(submitting: true, error: null);
    final result = await _resolveReport(
      ResolveReportParams(
        reportKey: reportKey,
        userId: userId,
        issueText: issueText,
      ),
    );
    result.fold(
      (failure) {
        state = state.copyWith(submitting: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(submitting: false);
      },
    );
  }
}

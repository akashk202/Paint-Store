import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';

export 'report_event.dart';
export 'report_state.dart';

/// ReportBloc: manages issue reports — submit, list, and resolve.
class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;
  StreamSubscription? _reportsSub;

  ReportBloc({required this.repository}) : super(const ReportInitial()) {
    on<SubmitReport>(_onSubmit);
    on<SubscribeToReports>(_onSubscribe);
    on<ReportsDataUpdated>(_onReportsUpdated);
    on<ResolveReport>(_onResolve);
  }

  Future<void> _onSubmit(
    SubmitReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    try {
      await repository.submitIssue(event.issueText);
      emit(const ReportSubmitted());
    } catch (e) {
      emit(ReportError('Failed to submit report: ${e.toString()}'));
    }
  }

  Future<void> _onSubscribe(
    SubscribeToReports event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    await _reportsSub?.cancel();
    _reportsSub = repository.reportsStream().listen(
      (reports) => add(ReportsDataUpdated(reports)),
      onError: (error) =>
          emit(ReportError('Failed to load reports: ${error.toString()}')),
    );
  }

  void _onReportsUpdated(
    ReportsDataUpdated event,
    Emitter<ReportState> emit,
  ) {
    emit(ReportsLoaded(event.reports));
  }

  Future<void> _onResolve(
    ResolveReport event,
    Emitter<ReportState> emit,
  ) async {
    try {
      await repository.resolveReport(
        reportKey: event.reportKey,
        userId: event.userId,
        issueText: event.issueText,
      );
      emit(const ReportResolved());
    } catch (e) {
      emit(ReportError('Failed to resolve report: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _reportsSub?.cancel();
    return super.close();
  }
}

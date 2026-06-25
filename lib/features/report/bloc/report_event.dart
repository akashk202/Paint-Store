import 'package:equatable/equatable.dart';

/// Events dispatched by the Report UI to the ReportBloc.
abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

/// Submit a new issue report.
class SubmitReport extends ReportEvent {
  final String issueText;

  const SubmitReport(this.issueText);

  @override
  List<Object?> get props => [issueText];
}

/// Subscribe to the reports stream (admin/manager view).
class SubscribeToReports extends ReportEvent {
  const SubscribeToReports();
}

/// Reports data updated from Firebase stream.
class ReportsDataUpdated extends ReportEvent {
  final List<MapEntry<String, Map<String, dynamic>>> reports;

  const ReportsDataUpdated(this.reports);

  @override
  List<Object?> get props => [reports];
}

/// Resolve a specific report (admin/manager action).
class ResolveReport extends ReportEvent {
  final String reportKey;
  final String userId;
  final String issueText;

  const ResolveReport({
    required this.reportKey,
    required this.userId,
    required this.issueText,
  });

  @override
  List<Object?> get props => [reportKey, userId, issueText];
}

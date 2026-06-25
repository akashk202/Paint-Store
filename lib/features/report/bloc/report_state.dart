import 'package:equatable/equatable.dart';

/// States emitted by the ReportBloc.
abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ReportInitial extends ReportState {
  const ReportInitial();
}

/// Report operation in progress.
class ReportLoading extends ReportState {
  const ReportLoading();
}

/// Report submitted successfully.
class ReportSubmitted extends ReportState {
  const ReportSubmitted();
}

/// Reports list loaded (admin/manager view).
class ReportsLoaded extends ReportState {
  final List<MapEntry<String, Map<String, dynamic>>> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

/// Report resolved successfully.
class ReportResolved extends ReportState {
  const ReportResolved();
}

/// An error occurred.
class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State for the VisualizerBloc.
/// Uses a single immutable state class with all fields.
class VisualizerState extends Equatable {
  final Color color;
  final String? resultUrl;
  final bool processing;
  final String? error;

  const VisualizerState({
    this.color = Colors.deepOrange,
    this.resultUrl,
    this.processing = false,
    this.error,
  });

  VisualizerState copyWith({
    Color? color,
    String? resultUrl,
    bool? processing,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return VisualizerState(
      color: color ?? this.color,
      resultUrl: clearResult ? null : (resultUrl ?? this.resultUrl),
      processing: processing ?? this.processing,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [color, resultUrl, processing, error];
}

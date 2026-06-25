import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Events dispatched by the Visualizer UI to the VisualizerBloc.
abstract class VisualizerEvent extends Equatable {
  const VisualizerEvent();

  @override
  List<Object?> get props => [];
}

/// User requested visualization of the image with the current color.
class VisualizerRequested extends VisualizerEvent {
  final File imageFile;
  final String scene;

  const VisualizerRequested(this.imageFile, {this.scene = 'auto'});

  @override
  List<Object?> get props => [imageFile.path, scene];
}

/// User changed the target color.
class VisualizerColorChanged extends VisualizerEvent {
  final Color color;

  const VisualizerColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

/// Clear the current result (e.g. after selecting a new image).
class VisualizerResultCleared extends VisualizerEvent {
  const VisualizerResultCleared();
}

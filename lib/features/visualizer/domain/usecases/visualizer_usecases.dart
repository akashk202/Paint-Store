import 'dart:io';
import '../repositories/visualizer_repository.dart';

class VisualizeImage {
  final VisualizerRepository repository;

  VisualizeImage(this.repository);

  Future<String> call({
    required File image,
    required String colorHex,
    required String scene,
  }) {
    return repository.visualizeImage(
      image: image,
      colorHex: colorHex,
      scene: scene,
    );
  }
}


// implements UseCase

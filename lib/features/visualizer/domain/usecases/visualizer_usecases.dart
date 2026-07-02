import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/visualizer_repository.dart';

class VisualizeImage implements UseCase<String, VisualizeImageParams> {
  final VisualizerRepository repository;

  VisualizeImage(this.repository);

  @override
  Future<Either<Failure, String>> call(VisualizeImageParams params) {
    return repository.visualizeImage(
      image: params.image,
      colorHex: params.colorHex,
      scene: params.scene,
    );
  }
}

class VisualizeImageParams extends Equatable {
  final File image;
  final String colorHex;
  final String scene;

  const VisualizeImageParams({
    required this.image,
    required this.colorHex,
    required this.scene,
  });

  @override
  List<Object?> get props => [image, colorHex, scene];
}

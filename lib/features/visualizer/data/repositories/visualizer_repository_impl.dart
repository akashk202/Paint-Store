import 'dart:io';

import '../../domain/repositories/visualizer_repository.dart';
import '../datasources/visualizer_remote_datasource.dart';

class VisualizerRepositoryImpl implements VisualizerRepository {
  final VisualizerRemoteDataSource remoteDataSource;

  VisualizerRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> visualizeImage({
    required File image,
    required String colorHex,
    required String scene,
  }) {
    return remoteDataSource.visualizeImage(
      image: image,
      colorHex: colorHex,
      scene: scene,
    );
  }
}

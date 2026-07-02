import 'dart:io';

abstract class VisualizerRepository {
  Future<String> visualizeImage({
    required File image,
    required String colorHex,
    required String scene,
  });
}


// Either<Failure, T>

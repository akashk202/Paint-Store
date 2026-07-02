import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';

abstract class VisualizerRepository {
  Future<Either<Failure, String>> visualizeImage({
    required File image,
    required String colorHex,
    required String scene,
  });
}

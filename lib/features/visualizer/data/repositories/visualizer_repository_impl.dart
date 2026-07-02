import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/repositories/visualizer_repository.dart';
import '../datasources/visualizer_remote_datasource.dart';

class VisualizerRepositoryImpl implements VisualizerRepository {
  final VisualizerRemoteDataSource remoteDataSource;

  VisualizerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> visualizeImage({
    required File image,
    required String colorHex,
    required String scene,
  }) async {
    try {
      final result = await remoteDataSource.visualizeImage(
        image: image,
        colorHex: colorHex,
        scene: scene,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

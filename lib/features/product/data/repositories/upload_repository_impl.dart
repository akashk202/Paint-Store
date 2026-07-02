import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../../../core/services/cloudinary_upload_service.dart';
import '../../domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  @override
  Future<Either<Failure, String>> uploadRaw(File file, {required String folder}) async {
    try {
      final result = await CloudinaryUploadService.uploadRaw(file, folder: folder);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File file, {required String folder}) async {
    try {
      final result = await CloudinaryUploadService.uploadImage(file, folder: folder);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';

abstract class UploadRepository {
  Future<Either<Failure, String>> uploadRaw(File file, {required String folder});
  Future<Either<Failure, String>> uploadImage(File file, {required String folder});
}

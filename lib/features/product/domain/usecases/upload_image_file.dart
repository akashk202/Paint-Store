import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/upload_repository.dart';

class UploadImageFile implements UseCase<String, UploadFileParams> {
  final UploadRepository repository;

  UploadImageFile(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) {
    return repository.uploadImage(params.file, folder: params.folder);
  }
}

class UploadFileParams extends Equatable {
  final File file;
  final String folder;

  const UploadFileParams({required this.file, required this.folder});

  @override
  List<Object?> get props => [file, folder];
}

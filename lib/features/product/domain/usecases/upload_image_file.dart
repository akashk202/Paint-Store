import 'dart:io';
import '../repositories/upload_repository.dart';

class UploadImageFile {
  final UploadRepository repository;

  UploadImageFile(this.repository);

  Future<String> call(File file, {required String folder}) {
    return repository.uploadImage(file, folder: folder);
  }
}


// implements UseCase

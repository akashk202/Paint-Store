import 'dart:io';
import '../repositories/upload_repository.dart';

class UploadRawFile {
  final UploadRepository repository;

  UploadRawFile(this.repository);

  Future<String> call(File file, {required String folder}) {
    return repository.uploadRaw(file, folder: folder);
  }
}

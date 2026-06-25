import 'dart:io';
import '../../../../core/services/cloudinary_upload_service.dart';
import '../../domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  @override
  Future<String> uploadRaw(File file, {required String folder}) {
    return CloudinaryUploadService.uploadRaw(file, folder: folder);
  }

  @override
  Future<String> uploadImage(File file, {required String folder}) {
    return CloudinaryUploadService.uploadImage(file, folder: folder);
  }
}

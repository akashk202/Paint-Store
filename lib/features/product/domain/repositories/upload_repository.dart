import 'dart:io';

abstract class UploadRepository {
  Future<String> uploadRaw(File file, {required String folder});
  Future<String> uploadImage(File file, {required String folder});
}

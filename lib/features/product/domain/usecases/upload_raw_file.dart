import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/upload_repository.dart';
import 'upload_image_file.dart'; // To reuse UploadFileParams

class UploadRawFile implements UseCase<String, UploadFileParams> {
  final UploadRepository repository;

  UploadRawFile(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) {
    return repository.uploadRaw(params.file, folder: params.folder);
  }
}

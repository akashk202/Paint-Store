import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateProfilePicture implements UseCase<String, File> {
  final UserRepository repository;

  UpdateProfilePicture(this.repository);

  @override
  Future<Either<Failure, String>> call(File params) {
    return repository.updateProfilePicture(params);
  }
}

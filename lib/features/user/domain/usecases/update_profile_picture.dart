import 'dart:io';
import '../repositories/user_repository.dart';

class UpdateProfilePicture {
  final UserRepository repository;
  UpdateProfilePicture(this.repository);

  Future<String> call(File imageFile) => repository.updateProfilePicture(imageFile);
}

class DeleteProfilePicture {
  final UserRepository repository;
  DeleteProfilePicture(this.repository);

  Future<void> call() => repository.deleteProfilePicture();
}

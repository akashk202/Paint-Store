import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateUserPassword implements UseCase<void, UpdateUserPasswordParams> {
  final UserRepository repository;

  UpdateUserPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserPasswordParams params) {
    return repository.updateUserPassword(params.currentPassword, params.newPassword);
  }
}

class UpdateUserPasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const UpdateUserPasswordParams({required this.currentPassword, required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

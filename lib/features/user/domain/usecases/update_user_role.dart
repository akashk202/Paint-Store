import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateUserRole implements UseCase<void, UpdateUserRoleParams> {
  final UserRepository repository;

  UpdateUserRole(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserRoleParams params) {
    return repository.updateUserRole(params.uid, params.role);
  }
}

class UpdateUserRoleParams extends Equatable {
  final String uid;
  final String role;

  const UpdateUserRoleParams({required this.uid, required this.role});

  @override
  List<Object?> get props => [uid, role];
}

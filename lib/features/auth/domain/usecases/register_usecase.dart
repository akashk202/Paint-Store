import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';
import 'package:c_h_p/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      address: params.address,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String address;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
  });

  @override
  List<Object?> get props => [name, email, phone, password, address];
}

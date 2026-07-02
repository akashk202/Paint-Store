import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/checkout_repository.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final CheckoutRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(
      fullName: params.fullName,
      phone: params.phone,
      email: params.email,
      address: params.address,
      lat: params.lat,
      lng: params.lng,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final double? lat;
  final double? lng;

  const UpdateUserProfileParams({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    this.lat,
    this.lng,
  });

  @override
  List<Object?> get props => [fullName, phone, email, address, lat, lng];
}

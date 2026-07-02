import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(
      name: params.name,
      phone: params.phone,
      address: params.address,
      pincode: params.pincode,
      lat: params.lat,
      lng: params.lng,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String name;
  final String phone;
  final String address;
  final String pincode;
  final double? lat;
  final double? lng;

  const UpdateUserProfileParams({
    required this.name,
    required this.phone,
    required this.address,
    required this.pincode,
    this.lat,
    this.lng,
  });

  @override
  List<Object?> get props => [name, phone, address, pincode, lat, lng];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class UpdateQuantity implements UseCase<void, UpdateQuantityParams> {
  final CartRepository repository;

  UpdateQuantity(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateQuantityParams params) {
    return repository.updateQuantity(
      productKey: params.productKey,
      quantity: params.quantity,
    );
  }
}

class UpdateQuantityParams extends Equatable {
  final String productKey;
  final int quantity;

  const UpdateQuantityParams({required this.productKey, required this.quantity});

  @override
  List<Object?> get props => [productKey, quantity];
}

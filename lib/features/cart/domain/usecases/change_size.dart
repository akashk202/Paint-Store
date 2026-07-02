import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class ChangeSize implements UseCase<void, ChangeSizeParams> {
  final CartRepository repository;

  ChangeSize(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeSizeParams params) {
    return repository.changeSize(
      productKey: params.productKey,
      size: params.size,
      price: params.price,
    );
  }
}

class ChangeSizeParams extends Equatable {
  final String productKey;
  final String size;
  final String price;

  const ChangeSizeParams({
    required this.productKey,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, size, price];
}

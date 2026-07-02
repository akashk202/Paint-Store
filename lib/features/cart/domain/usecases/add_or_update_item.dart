import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class AddOrUpdateItem implements UseCase<void, AddOrUpdateItemParams> {
  final CartRepository repository;

  AddOrUpdateItem(this.repository);

  @override
  Future<Either<Failure, void>> call(AddOrUpdateItemParams params) {
    return repository.addOrUpdateItem(
      productKey: params.productKey,
      name: params.name,
      imageUrl: params.imageUrl,
      size: params.size,
      price: params.price,
    );
  }
}

class AddOrUpdateItemParams extends Equatable {
  final String productKey;
  final String name;
  final String imageUrl;
  final String size;
  final String price;

  const AddOrUpdateItemParams({
    required this.productKey,
    required this.name,
    required this.imageUrl,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [productKey, name, imageUrl, size, price];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class UpdateProduct implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    return repository.updateProduct(params.key, params.data);
  }
}

class UpdateProductParams extends Equatable {
  final String key;
  final Map<String, dynamic> data;

  const UpdateProductParams({required this.key, required this.data});

  @override
  List<Object?> get props => [key, data];
}

import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class AddProduct implements UseCase<void, Map<String, dynamic>> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(Map<String, dynamic> params) {
    return repository.addProduct(params);
  }
}

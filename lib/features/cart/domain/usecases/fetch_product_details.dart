import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class FetchProductDetails implements UseCase<Map<String, Map<String, dynamic>?>, List<String>> {
  final CartRepository repository;

  FetchProductDetails(this.repository);

  @override
  Future<Either<Failure, Map<String, Map<String, dynamic>?>>> call(List<String> params) {
    return repository.fetchProductDetails(params);
  }
}

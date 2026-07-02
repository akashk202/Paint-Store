import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/home_product_entity.dart';
import '../repositories/home_repository.dart';

class GetAllHomeProducts implements UseCase<List<HomeProductEntity>, NoParams> {
  final HomeRepository repository;

  GetAllHomeProducts(this.repository);

  @override
  Future<Either<Failure, List<HomeProductEntity>>> call(NoParams params) {
    return repository.fetchAllProducts();
  }
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/stock_repository.dart';

class WatchStock implements StreamUseCase<List<Product>, NoParams> {
  final StockRepository repository;

  WatchStock(this.repository);

  @override
  Stream<List<Product>> call(NoParams params) {
    return repository.watchStock();
  }
}

class UpdateStock implements UseCase<void, UpdateStockParams> {
  final StockRepository repository;

  UpdateStock(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateStockParams params) {
    return repository.updateStock(params.productKey, params.newStock);
  }
}

class UpdateStockParams extends Equatable {
  final String productKey;
  final int newStock;

  const UpdateStockParams({required this.productKey, required this.newStock});

  @override
  List<Object?> get props => [productKey, newStock];
}

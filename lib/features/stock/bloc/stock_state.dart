import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/product_model.dart';

/// States emitted by the StockBloc.
abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

/// Initial state before stock data is loaded.
class StockInitial extends StockState {
  const StockInitial();
}

/// Stock data is being loaded.
class StockLoading extends StockState {
  const StockLoading();
}

/// Stock data loaded successfully.
class StockLoaded extends StockState {
  final List<Product> products;

  const StockLoaded(this.products);

  List<Product> get lowStockProducts =>
      products.where((p) => p.stock > 0 && p.stock <= 5).toList();

  List<Product> get outOfStockProducts =>
      products.where((p) => p.stock <= 0).toList();

  @override
  List<Object?> get props => [products];
}

/// An error occurred while loading stock data.
class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:c_h_p/model/product_model.dart';

/// Events dispatched by the Stock UI to the StockBloc.
abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object?> get props => [];
}

/// Subscribe to real-time product stock stream.
class SubscribeToStock extends StockEvent {
  const SubscribeToStock();
}

/// Stock data updated from the Firebase stream.
class StockDataUpdated extends StockEvent {
  final List<Product> products;

  const StockDataUpdated(this.products);

  @override
  List<Object?> get props => [products];
}

/// Update the stock level of a specific product.
class UpdateProductStock extends StockEvent {
  final String productKey;
  final int newStock;

  const UpdateProductStock({required this.productKey, required this.newStock});

  @override
  List<Object?> get props => [productKey, newStock];
}

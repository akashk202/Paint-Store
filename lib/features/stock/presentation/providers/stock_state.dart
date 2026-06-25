import 'package:c_h_p/features/product/data/models/product_model.dart';class StockState {
  final bool loading;
  final List<Product> products;
  final Object? error;

  const StockState({
    this.loading = false,
    this.products = const [],
    this.error,
  });

  StockState copyWith({
    bool? loading,
    List<Product>? products,
    Object? error,
  }) {
    return StockState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
    );
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';import '../../domain/usecases/stock_usecases.dart';
import 'stock_state.dart';

class StockNotifier extends StateNotifier<StockState> {
  final WatchStock _watchStock;
  final UpdateStock _updateStock;
  StreamSubscription<List<Product>>? _sub;

  StockNotifier({
    required WatchStock watchStock,
    required UpdateStock updateStock,
  })  : _watchStock = watchStock,
        _updateStock = updateStock,
        super(const StockState()) {
    _listen();
  }

  void _listen() {
    state = state.copyWith(loading: true, error: null);
    _sub?.cancel();
    _sub = _watchStock().listen(
      (list) {
        state = state.copyWith(loading: false, products: list, error: null);
      },
      onError: (e) {
        state = state.copyWith(loading: false, error: e);
      },
    );
  }

  Future<void> updateStock(String productKey, int newStock) {
    return _updateStock(productKey, newStock);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

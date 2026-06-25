import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/data/repositories/stock_repository.dart';
import 'stock_event.dart';
import 'stock_state.dart';

export 'stock_event.dart';
export 'stock_state.dart';

/// StockBloc: manages real-time stock monitoring via Firebase stream.
class StockBloc extends Bloc<StockEvent, StockState> {
  final StockRepository repository;
  StreamSubscription? _stockSub;

  StockBloc({required this.repository}) : super(const StockInitial()) {
    on<SubscribeToStock>(_onSubscribe);
    on<StockDataUpdated>(_onStockUpdated);
    on<UpdateProductStock>(_onUpdateStock);
  }

  Future<void> _onSubscribe(
    SubscribeToStock event,
    Emitter<StockState> emit,
  ) async {
    emit(const StockLoading());
    await _stockSub?.cancel();
    _stockSub = repository.productsStream().listen(
      (products) => add(StockDataUpdated(products)),
      onError: (error) =>
          emit(StockError('Failed to load stock: ${error.toString()}')),
    );
  }

  void _onStockUpdated(
    StockDataUpdated event,
    Emitter<StockState> emit,
  ) {
    emit(StockLoaded(event.products));
  }

  Future<void> _onUpdateStock(
    UpdateProductStock event,
    Emitter<StockState> emit,
  ) async {
    try {
      await repository.updateStock(event.productKey, event.newStock);
    } catch (e) {
      emit(StockError('Failed to update stock: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _stockSub?.cancel();
    return super.close();
  }
}

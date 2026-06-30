import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../data/datasources/stock_remote_datasource.dart';
import '../../data/repositories/stock_repository_impl.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/usecases/stock_usecases.dart';
import 'stock_state.dart';
import 'stock_notifier.dart';

final _stockRemoteDataSourceProvider = Provider<StockRemoteDataSource>((ref) {
  return StockRemoteDataSourceImpl(FirebaseDatabase.instance.ref());
});

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepositoryImpl(ref.read(_stockRemoteDataSourceProvider));
});

final watchStockUseCaseProvider = Provider<WatchStock>((ref) {
  return WatchStock(ref.read(stockRepositoryProvider));
});

final updateStockUseCaseProvider = Provider<UpdateStock>((ref) {
  return UpdateStock(ref.read(stockRepositoryProvider));
});

final stockNotifierProvider = StateNotifierProvider<StockNotifier, StockState>((ref) {
  return StockNotifier(
    watchStock: ref.read(watchStockUseCaseProvider),
    updateStock: ref.read(updateStockUseCaseProvider),
  );
});

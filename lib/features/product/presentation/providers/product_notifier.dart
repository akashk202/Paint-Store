import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_providers.dart';

class ProductNotifier extends AsyncNotifier<void> {
  late final ProductRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(productRepositoryProvider);
  }

  Future<bool> deleteProduct(String key) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteProduct(key);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateProduct(String key, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateProduct(key, data);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final productNotifierProvider = AsyncNotifierProvider<ProductNotifier, void>(() {
  return ProductNotifier();
});

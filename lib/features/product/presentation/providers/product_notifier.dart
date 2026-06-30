import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_providers.dart';

class ProductNotifier extends AsyncNotifier<void> {
  late final DeleteProduct _deleteProduct;
  late final UpdateProduct _updateProduct;

  @override
  FutureOr<void> build() {
    _deleteProduct = ref.watch(deleteProductUseCaseProvider);
    _updateProduct = ref.watch(updateProductUseCaseProvider);
  }

  Future<bool> deleteProduct(String key) async {
    state = const AsyncValue.loading();
    try {
      await _deleteProduct(key);
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
      await _updateProduct(key, data);
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

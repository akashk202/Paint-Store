import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final AddProduct _addProduct;
  final DeleteProduct _deleteProduct;
  final UpdateProduct _updateProduct;

  ProductNotifier({
    required AddProduct addProduct,
    required DeleteProduct deleteProduct,
    required UpdateProduct updateProduct,
  })  : _addProduct = addProduct,
        _deleteProduct = deleteProduct,
        _updateProduct = updateProduct,
        super(const ProductState());

  Future<bool> addProduct(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final result = await _addProduct(data);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> deleteProduct(String key) async {
    state = state.copyWith(isLoading: true);
    final result = await _deleteProduct(key);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }

  Future<bool> updateProduct(String key, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final result = await _updateProduct(UpdateProductParams(key: key, data: data));
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
        return true;
      },
    );
  }
}

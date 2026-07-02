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
    try {
      await _addProduct(data);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(String key) async {
    state = state.copyWith(isLoading: true);
    try {
      await _deleteProduct(key);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateProduct(String key, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      await _updateProduct(key, data);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_products_by_filter.dart';
import 'product_display_state.dart';

class ProductDisplayNotifier extends StateNotifier<ProductDisplayState> {
  final GetProductsByFilter _getProductsByFilter;

  ProductDisplayNotifier({
    required GetProductsByFilter getProductsByFilter,
  })  : _getProductsByFilter = getProductsByFilter,
        super(const ProductDisplayState());

  Future<void> loadProducts({
    String? category,
    String? subCategory,
    String? brand,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final products = await _getProductsByFilter(
        category: category,
        subCategory: subCategory,
        brand: brand,
      );
      state = state.copyWith(loading: false, products: products);
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }
}

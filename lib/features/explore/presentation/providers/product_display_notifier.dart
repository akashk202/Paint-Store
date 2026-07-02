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
    final result = await _getProductsByFilter(
      GetProductsByFilterParams(
        category: category,
        subCategory: subCategory,
        brand: brand,
      ),
    );
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (products) {
        state = state.copyWith(loading: false, products: products);
      },
    );
  }
}

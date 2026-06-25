import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/products/domain/entities/product_entity.dart';
import 'package:c_h_p/features/products/domain/usecases/get_all_products_usecase.dart';
import 'package:c_h_p/features/products/domain/usecases/search_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

/// ProductBloc: handles product events via use cases.
/// Caches the full product list for search filtering.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  /// Cached product list to avoid redundant fetches.
  List<ProductEntity> _cachedProducts = [];

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());

    final result = await getAllProductsUseCase(const NoParams());

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _cachedProducts = products;
        emit(ProductLoaded(products));
      },
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(ProductLoaded(_cachedProducts));
      return;
    }

    emit(const ProductLoading());

    final result = await searchProductsUseCase(
      SearchParams(query: query),
    );

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductSearchResults(
        products: products,
        query: query,
      )),
    );
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<ProductState> emit,
  ) {
    if (_cachedProducts.isNotEmpty) {
      emit(ProductLoaded(_cachedProducts));
    } else {
      add(const LoadProducts());
    }
  }
}

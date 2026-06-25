import '../../domain/entities/explore_product_entity.dart';

class ProductDisplayState {
  final bool loading;
  final List<ExploreProductEntity> products;
  final Object? error;

  const ProductDisplayState({
    this.loading = false,
    this.products = const [],
    this.error,
  });

  ProductDisplayState copyWith({
    bool? loading,
    List<ExploreProductEntity>? products,
    Object? error,
  }) {
    return ProductDisplayState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
    );
  }
}

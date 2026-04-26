import '../../domain/entities/home_product_entity.dart';

class HomeState {
  final bool loading;
  final List<HomeProductEntity> products;
  final Object? error;
  final int unreadCount;

  const HomeState({
    this.loading = false,
    this.products = const [],
    this.error,
    this.unreadCount = 0,
  });

  HomeState copyWith({
    bool? loading,
    List<HomeProductEntity>? products,
    Object? error,
    int? unreadCount,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

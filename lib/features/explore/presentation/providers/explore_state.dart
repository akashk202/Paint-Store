import '../../domain/entities/explore_product_entity.dart';

class ExploreState {
  final bool loading;
  final List<ExploreProductEntity> items;
  final Object? error;

  const ExploreState({
    this.loading = false,
    this.items = const [],
    this.error,
  });

  ExploreState copyWith({
    bool? loading,
    List<ExploreProductEntity>? items,
    Object? error,
  }) {
    return ExploreState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
    );
  }
}

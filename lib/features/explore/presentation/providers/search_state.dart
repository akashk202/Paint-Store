import '../../domain/entities/explore_product_entity.dart';

class SearchState {
  final bool loading;
  final List<ExploreProductEntity> results;
  final List<ExploreProductEntity> suggestions;
  final Object? error;

  const SearchState({
    this.loading = false,
    this.results = const [],
    this.suggestions = const [],
    this.error,
  });

  SearchState copyWith({
    bool? loading,
    List<ExploreProductEntity>? results,
    List<ExploreProductEntity>? suggestions,
    Object? error,
  }) {
    return SearchState(
      loading: loading ?? this.loading,
      results: results ?? this.results,
      suggestions: suggestions ?? this.suggestions,
      error: error,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/search_products.dart';
import 'search_state.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchProducts searchProductsUseCase;

  SearchNotifier({
    required this.searchProductsUseCase,
  }) : super(const SearchState());

  Future<void> search(String query) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final results = await searchProductsUseCase(query);
      
      // If no results, we could fetch some suggestions. For now, we'll just return empty or random
      state = state.copyWith(
        loading: false,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }
}

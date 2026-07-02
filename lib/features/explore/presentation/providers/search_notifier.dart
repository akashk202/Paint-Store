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
    final result = await searchProductsUseCase(query);
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (results) {
        state = state.copyWith(
          loading: false,
          results: results,
        );
      },
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../../domain/usecases/fetch_all_shades.dart';
import 'color_catalogue_state.dart';

class ColorCatalogueNotifier extends StateNotifier<ColorCatalogueState> {
  final FetchAllShades _fetchAllShades;

  ColorCatalogueNotifier({
    required FetchAllShades fetchAllShades,
  })  : _fetchAllShades = fetchAllShades,
        super(const ColorCatalogueState());

  Future<void> loadShades() async {
    state = state.copyWith(loading: true, error: null);
    final result = await _fetchAllShades(const NoParams());
    result.fold(
      (failure) {
        state = state.copyWith(loading: false, error: failure.message);
      },
      (shades) {
        final categoriesSet = <String>{'All'};
        for (final s in shades) {
          categoriesSet.add(s.category);
        }
        final categories = categoriesSet.toList()
          ..sort((a, b) {
            if (a == 'All') return -1;
            if (b == 'All') return 1;
            return a.compareTo(b);
          });

        state = state.copyWith(
          loading: false,
          allShades: shades,
          categories: categories,
        );
      },
    );
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

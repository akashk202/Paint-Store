import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    try {
      final shades = await _fetchAllShades();
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
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

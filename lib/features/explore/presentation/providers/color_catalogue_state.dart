import '../../domain/entities/color_shade.dart';

class ColorCatalogueState {
  final bool loading;
  final List<ColorShade> allShades;
  final List<String> categories;
  final String selectedCategory;
  final Object? error;

  const ColorCatalogueState({
    this.loading = false,
    this.allShades = const [],
    this.categories = const ['All'],
    this.selectedCategory = 'All',
    this.error,
  });

  List<ColorShade> get filteredShades => selectedCategory == 'All'
      ? allShades
      : allShades.where((s) => s.category == selectedCategory).toList();

  ColorCatalogueState copyWith({
    bool? loading,
    List<ColorShade>? allShades,
    List<String>? categories,
    String? selectedCategory,
    Object? error,
  }) {
    return ColorCatalogueState(
      loading: loading ?? this.loading,
      allShades: allShades ?? this.allShades,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}

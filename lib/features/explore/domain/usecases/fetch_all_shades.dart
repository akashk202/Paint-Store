import '../entities/color_shade.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchAllShades {
  final ColorCatalogueRepository repository;

  FetchAllShades(this.repository);

  Future<List<ColorShade>> call() {
    return repository.fetchAllShades();
  }
}

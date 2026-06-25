import '../repositories/color_catalogue_repository.dart';

class GetLatestColorsStream {
  final ColorCatalogueRepository repository;

  GetLatestColorsStream(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.latestColorsStream();
  }
}

import '../repositories/color_catalogue_repository.dart';

class FetchShadeLink {
  final ColorCatalogueRepository repository;

  FetchShadeLink(this.repository);

  Future<Map<String, dynamic>?> call(String shadeCode) {
    return repository.fetchShadeLink(shadeCode);
  }
}


// implements UseCase

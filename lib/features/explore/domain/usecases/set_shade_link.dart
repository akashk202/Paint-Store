import '../repositories/color_catalogue_repository.dart';

class SetShadeLink {
  final ColorCatalogueRepository repository;

  SetShadeLink(this.repository);

  Future<void> call(String shadeCode, Map<String, dynamic> data) {
    return repository.setShadeLink(shadeCode, data);
  }
}

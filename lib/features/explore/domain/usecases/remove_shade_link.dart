import '../repositories/color_catalogue_repository.dart';

class RemoveShadeLink {
  final ColorCatalogueRepository repository;

  RemoveShadeLink(this.repository);

  Future<void> call(String shadeCode) {
    return repository.removeShadeLink(shadeCode);
  }
}


// implements UseCase

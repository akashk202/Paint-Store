import '../repositories/color_catalogue_repository.dart';

class GetColorCategoriesStream {
  final ColorCatalogueRepository repository;

  GetColorCategoriesStream(this.repository);

  Stream<Map<String, dynamic>> call() {
    return repository.colorCategoriesStream();
  }
}


// implements UseCase

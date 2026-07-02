import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class GetColorCategoriesStream implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ColorCatalogueRepository repository;

  GetColorCategoriesStream(this.repository);

  @override
  Stream<Map<String, dynamic>> call(NoParams params) {
    return repository.colorCategoriesStream();
  }
}

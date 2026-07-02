import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/color_shade.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchAllShades implements UseCase<List<ColorShade>, NoParams> {
  final ColorCatalogueRepository repository;

  FetchAllShades(this.repository);

  @override
  Future<Either<Failure, List<ColorShade>>> call(NoParams params) {
    return repository.fetchAllShades();
  }
}

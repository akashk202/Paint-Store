import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class RemoveShadeLink implements UseCase<void, String> {
  final ColorCatalogueRepository repository;

  RemoveShadeLink(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.removeShadeLink(params);
  }
}

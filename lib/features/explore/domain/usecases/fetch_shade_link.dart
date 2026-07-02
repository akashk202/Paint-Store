import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchShadeLink implements UseCase<Map<String, dynamic>?, String> {
  final ColorCatalogueRepository repository;

  FetchShadeLink(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>?>> call(String params) {
    return repository.fetchShadeLink(params);
  }
}

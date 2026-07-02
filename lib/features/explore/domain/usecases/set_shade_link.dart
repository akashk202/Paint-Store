import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class SetShadeLink implements UseCase<void, SetShadeLinkParams> {
  final ColorCatalogueRepository repository;

  SetShadeLink(this.repository);

  @override
  Future<Either<Failure, void>> call(SetShadeLinkParams params) {
    return repository.setShadeLink(params.shadeCode, params.data);
  }
}

class SetShadeLinkParams extends Equatable {
  final String shadeCode;
  final Map<String, dynamic> data;

  const SetShadeLinkParams({required this.shadeCode, required this.data});

  @override
  List<Object?> get props => [shadeCode, data];
}

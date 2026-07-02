import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/color_shade.dart';
import '../../domain/repositories/color_catalogue_repository.dart';
import '../datasources/color_catalogue_remote_datasource.dart';
import 'package:c_h_p/features/product/data/models/product_model.dart';

class ColorCatalogueRepositoryImpl implements ColorCatalogueRepository {
  final ColorCatalogueRemoteDataSource remoteDataSource;

  ColorCatalogueRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ColorShade>>> fetchAllShades() async {
    try {
      final result = await remoteDataSource.fetchAllShades();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product?>> resolveLinkedProduct(String shadeCode) async {
    try {
      final result = await remoteDataSource.resolveLinkedProduct(shadeCode);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> fetchProductsByShadeName(String shadeName) async {
    try {
      final result = await remoteDataSource.fetchProductsByShadeName(shadeName);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Map<String, dynamic>> latestColorsStream() {
    return remoteDataSource.latestColorsStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value);
    });
  }

  @override
  Stream<Map<String, dynamic>> colorCategoriesStream() {
    return remoteDataSource.colorCategoriesStream().map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return const <String, dynamic>{};
      }
      return Map<String, dynamic>.from(value);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> fetchShadeLink(String shadeCode) async {
    try {
      final result = await remoteDataSource.fetchShadeLink(shadeCode);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setShadeLink(String shadeCode, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.setShadeLink(shadeCode, data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeShadeLink(String shadeCode) async {
    try {
      await remoteDataSource.removeShadeLink(shadeCode);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import os

workspace_dir = r"c:\Users\AK\Documents\Paint-Store"
usecases_dir = os.path.join(workspace_dir, "lib", "features", "explore", "domain", "usecases")

# 1. fetch_all_shades.dart
with open(os.path.join(usecases_dir, "fetch_all_shades.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
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
''')

# 2. fetch_products_by_shade_name.dart
with open(os.path.join(usecases_dir, "fetch_products_by_shade_name.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/color_catalogue_repository.dart';

class FetchProductsByShadeName implements UseCase<List<Product>, String> {
  final ColorCatalogueRepository repository;

  FetchProductsByShadeName(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String params) {
    return repository.fetchProductsByShadeName(params);
  }
}
''')

# 3. fetch_shade_link.dart
with open(os.path.join(usecases_dir, "fetch_shade_link.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
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
''')

# 4. get_color_categories_stream.dart
with open(os.path.join(usecases_dir, "get_color_categories_stream.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class GetColorCategoriesStream implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ColorCatalogueRepository repository;

  GetColorCategoriesStream(this.repository);

  @override
  Stream<Map<String, dynamic>> call(NoParams params) {
    return repository.colorCategoriesStream();
  }
}
''')

# 5. get_latest_colors_stream.dart
with open(os.path.join(usecases_dir, "get_latest_colors_stream.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:c_h_p/core/usecases/usecase.dart';
import '../repositories/color_catalogue_repository.dart';

class GetLatestColorsStream implements StreamUseCase<Map<String, dynamic>, NoParams> {
  final ColorCatalogueRepository repository;

  GetLatestColorsStream(this.repository);

  @override
  Stream<Map<String, dynamic>> call(NoParams params) {
    return repository.latestColorsStream();
  }
}
''')

# 6. get_products_by_filter.dart
with open(os.path.join(usecases_dir, "get_products_by_filter.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetProductsByFilter implements UseCase<List<ExploreProductEntity>, GetProductsByFilterParams> {
  final ExploreRepository repository;

  GetProductsByFilter(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(GetProductsByFilterParams params) {
    return repository.fetchProductsByFilter(
      category: params.category,
      subCategory: params.subCategory,
      brand: params.brand,
    );
  }
}

class GetProductsByFilterParams extends Equatable {
  final String? category;
  final String? subCategory;
  final String? brand;

  const GetProductsByFilterParams({
    this.category,
    this.subCategory,
    this.brand,
  });

  @override
  List<Object?> get props => [category, subCategory, brand];
}
''')

# 7. get_recommended_products.dart
with open(os.path.join(usecases_dir, "get_recommended_products.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetRecommendedProducts implements UseCase<List<ExploreProductEntity>, int> {
  final ExploreRepository repository;

  GetRecommendedProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(int params) {
    return repository.fetchRecommended(limit: params);
  }
}
''')

# 8. get_similar_products.dart
with open(os.path.join(usecases_dir, "get_similar_products.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class GetSimilarProducts implements UseCase<List<ExploreProductEntity>, GetSimilarProductsParams> {
  final ExploreRepository repository;

  GetSimilarProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(GetSimilarProductsParams params) {
    return repository.fetchSimilarProducts(params.anchor, limit: params.limit);
  }
}

class GetSimilarProductsParams extends Equatable {
  final Product anchor;
  final int limit;

  const GetSimilarProductsParams({required this.anchor, this.limit = 10});

  @override
  List<Object?> get props => [anchor, limit];
}
''')

# 9. remove_shade_link.dart
with open(os.path.join(usecases_dir, "remove_shade_link.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
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
''')

# 10. resolve_linked_product.dart
with open(os.path.join(usecases_dir, "resolve_linked_product.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import 'package:c_h_p/features/product/domain/entities/product_entity.dart';
import '../repositories/color_catalogue_repository.dart';

class ResolveLinkedProduct implements UseCase<Product?, String> {
  final ColorCatalogueRepository repository;

  ResolveLinkedProduct(this.repository);

  @override
  Future<Either<Failure, Product?>> call(String params) {
    return repository.resolveLinkedProduct(params);
  }
}
''')

# 11. search_products.dart
with open(os.path.join(usecases_dir, "search_products.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import 'package:c_h_p/core/usecases/usecase.dart';
import '../entities/explore_product_entity.dart';
import '../repositories/explore_repository.dart';

class SearchProducts implements UseCase<List<ExploreProductEntity>, String> {
  final ExploreRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<ExploreProductEntity>>> call(String params) {
    return repository.searchProducts(params);
  }
}
''')

# 12. set_shade_link.dart
with open(os.path.join(usecases_dir, "set_shade_link.dart"), "w", encoding="utf-8") as f:
    f.write('''import 'package:dartz/dartz.dart';
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
''')

print("All explore usecases refactored successfully!")

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/explore_product_entity.dart';
import '../../data/datasources/explore_remote_datasource.dart';
import '../../data/datasources/color_catalogue_remote_datasource.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../domain/repositories/explore_repository.dart';
import '../../domain/usecases/get_recommended_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_products_by_filter.dart';
import 'explore_state.dart';
import 'explore_notifier.dart';
import 'search_state.dart';
import 'search_notifier.dart';
import 'product_display_state.dart';
import 'product_display_notifier.dart';
import 'color_catalogue_state.dart';
import 'color_catalogue_notifier.dart';

final exploreRemoteDataSourceProvider = Provider<ExploreRemoteDataSource>((ref) {
  return ExploreRemoteDataSourceImpl();
});

final colorCatalogueDataSourceProvider =
    Provider<ColorCatalogueRemoteDataSource>((ref) {
  return ColorCatalogueRemoteDataSourceImpl();
});

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  final remoteDataSource = ref.read(exploreRemoteDataSourceProvider);
  return ExploreRepositoryImpl(remoteDataSource);
});

final getRecommendedProductsUseCaseProvider = Provider<GetRecommendedProducts>((ref) {
  final repository = ref.read(exploreRepositoryProvider);
  return GetRecommendedProducts(repository);
});

final searchProductsUseCaseProvider = Provider<SearchProducts>((ref) {
  final repository = ref.read(exploreRepositoryProvider);
  return SearchProducts(repository);
});

final getProductsByFilterUseCaseProvider = Provider<GetProductsByFilter>((ref) {
  final repository = ref.read(exploreRepositoryProvider);
  return GetProductsByFilter(repository);
});

final exploreNotifierProvider = StateNotifierProvider<ExploreNotifier, ExploreState>((ref) {
  return ExploreNotifier(
    getRecommendedProducts: ref.read(getRecommendedProductsUseCaseProvider),
  );
});

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    searchProductsUseCase: ref.read(searchProductsUseCaseProvider),
  );
});

final productDisplayNotifierProvider =
    StateNotifierProvider<ProductDisplayNotifier, ProductDisplayState>((ref) {
  return ProductDisplayNotifier(
    getProductsByFilter: ref.read(getProductsByFilterUseCaseProvider),
  );
});

final colorCatalogueNotifierProvider =
    StateNotifierProvider<ColorCatalogueNotifier, ColorCatalogueState>((ref) {
  return ColorCatalogueNotifier(
    dataSource: ref.read(colorCatalogueDataSourceProvider),
  );
});

// Optional read-only provider for one-shot consumers.
final recommendedProductsProvider =
    FutureProvider<List<ExploreProductEntity>>((ref) async {
  final useCase = ref.read(getRecommendedProductsUseCaseProvider);
  return useCase(limit: 10);
});


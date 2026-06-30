import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/explore_product_entity.dart';
import '../../data/datasources/explore_remote_datasource.dart';
import '../../data/datasources/color_catalogue_remote_datasource.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../data/repositories/color_catalogue_repository_impl.dart';
import '../../domain/repositories/explore_repository.dart';
import '../../domain/repositories/color_catalogue_repository.dart';
import '../../domain/usecases/get_recommended_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_products_by_filter.dart';
import '../../domain/usecases/get_similar_products.dart';
import '../../domain/usecases/fetch_all_shades.dart';
import '../../domain/usecases/resolve_linked_product.dart';
import '../../domain/usecases/fetch_products_by_shade_name.dart';
import '../../domain/usecases/get_latest_colors_stream.dart';
import '../../domain/usecases/get_color_categories_stream.dart';
import '../../domain/usecases/fetch_shade_link.dart';
import '../../domain/usecases/set_shade_link.dart';
import '../../domain/usecases/remove_shade_link.dart';
import 'explore_state.dart';
import 'explore_notifier.dart';
import 'search_state.dart';
import 'search_notifier.dart';
import 'product_display_state.dart';
import 'product_display_notifier.dart';
import 'color_catalogue_state.dart';
import 'color_catalogue_notifier.dart';

final _exploreRemoteDataSourceProvider = Provider<ExploreRemoteDataSource>((ref) {
  return ExploreRemoteDataSourceImpl();
});

final _colorCatalogueDataSourceProvider =
    Provider<ColorCatalogueRemoteDataSource>((ref) {
  return ColorCatalogueRemoteDataSourceImpl();
});

final colorCatalogueRepositoryProvider = Provider<ColorCatalogueRepository>((ref) {
  final dataSource = ref.read(_colorCatalogueDataSourceProvider);
  return ColorCatalogueRepositoryImpl(dataSource);
});

final fetchAllShadesUseCaseProvider = Provider<FetchAllShades>((ref) {
  return FetchAllShades(ref.read(colorCatalogueRepositoryProvider));
});

final resolveLinkedProductUseCaseProvider = Provider<ResolveLinkedProduct>((ref) {
  return ResolveLinkedProduct(ref.read(colorCatalogueRepositoryProvider));
});

final fetchProductsByShadeNameUseCaseProvider = Provider<FetchProductsByShadeName>((ref) {
  return FetchProductsByShadeName(ref.read(colorCatalogueRepositoryProvider));
});

final getLatestColorsStreamUseCaseProvider = Provider<GetLatestColorsStream>((ref) {
  return GetLatestColorsStream(ref.read(colorCatalogueRepositoryProvider));
});

final getColorCategoriesStreamUseCaseProvider = Provider<GetColorCategoriesStream>((ref) {
  return GetColorCategoriesStream(ref.read(colorCatalogueRepositoryProvider));
});

final fetchShadeLinkUseCaseProvider = Provider<FetchShadeLink>((ref) {
  return FetchShadeLink(ref.read(colorCatalogueRepositoryProvider));
});

final setShadeLinkUseCaseProvider = Provider<SetShadeLink>((ref) {
  return SetShadeLink(ref.read(colorCatalogueRepositoryProvider));
});

final removeShadeLinkUseCaseProvider = Provider<RemoveShadeLink>((ref) {
  return RemoveShadeLink(ref.read(colorCatalogueRepositoryProvider));
});

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  final remoteDataSource = ref.read(_exploreRemoteDataSourceProvider);
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

final getSimilarProductsUseCaseProvider = Provider<GetSimilarProducts>((ref) {
  final repository = ref.read(exploreRepositoryProvider);
  return GetSimilarProducts(repository);
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
    fetchAllShades: ref.read(fetchAllShadesUseCaseProvider),
  );
});

// Optional read-only provider for one-shot consumers.
final recommendedProductsProvider =
    FutureProvider<List<ExploreProductEntity>>((ref) async {
  final useCase = ref.read(getRecommendedProductsUseCaseProvider);
  return useCase(limit: 10);
});


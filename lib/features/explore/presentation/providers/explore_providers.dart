import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/explore_product_entity.dart';
import '../../data/datasources/explore_remote_datasource.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../domain/repositories/explore_repository.dart';
import '../../domain/usecases/get_recommended_products.dart';
import '../../domain/usecases/search_products.dart';
import 'explore_state.dart';
import 'explore_notifier.dart';
import 'search_state.dart';
import 'search_notifier.dart';

final exploreRemoteDataSourceProvider = Provider<ExploreRemoteDataSource>((ref) {
  return ExploreRemoteDataSourceImpl();
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

// Optional read-only provider for one-shot consumers.
final recommendedProductsProvider =
    FutureProvider<List<ExploreProductEntity>>((ref) async {
  final useCase = ref.read(getRecommendedProductsUseCaseProvider);
  return useCase(limit: 10);
});

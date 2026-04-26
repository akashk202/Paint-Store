import '../../domain/entities/explore_product_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ExploreProductEntity>> fetchRecommended({int limit = 10}) {
    return remoteDataSource.fetchRecommended(limit: limit);
  }

  @override
  Future<List<ExploreProductEntity>> searchProducts(String query) {
    return remoteDataSource.searchProducts(query);
  }
}

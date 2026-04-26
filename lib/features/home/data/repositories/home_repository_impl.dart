import '../../domain/entities/home_product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HomeProductEntity>> fetchAllProducts() {
    return remoteDataSource.fetchAllProducts();
  }

  @override
  Stream<int> unreadCountStream(String uid) {
    return remoteDataSource.unreadCountStream(uid);
  }
}

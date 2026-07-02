import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/home_product_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<HomeProductEntity>>> fetchAllProducts() async {
    try {
      final result = await remoteDataSource.fetchAllProducts();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<int> unreadCountStream(String uid) {
    return remoteDataSource.unreadCountStream(uid);
  }
}

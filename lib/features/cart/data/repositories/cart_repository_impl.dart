import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;

  CartRepositoryImpl(this.remote);

  @override
  Stream<List<CartItem>> cartStream() {
    return remote.cartStream().map((map) {
      return map.entries.map((e) {
        return CartItemModel.fromMap(e.key, e.value);
      }).toList();
    });
  }

  @override
  Future<Either<Failure, void>> updateQuantity({
    required String productKey,
    required int quantity,
  }) async {
    try {
      await remote.updateQuantity(
        productKey: productKey,
        quantity: quantity,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changeSize({
    required String productKey,
    required String size,
    required String price,
  }) async {
    try {
      await remote.changeSize(
        productKey: productKey,
        size: size,
        price: price,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String productKey) async {
    try {
      await remote.removeItem(productKey);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remote.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  }) async {
    try {
      await remote.addOrUpdateItem(
        productKey: productKey,
        name: name,
        imageUrl: imageUrl,
        size: size,
        price: price,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, Map<String, dynamic>?>>> fetchProductDetails(
    List<String> productKeys,
  ) async {
    try {
      final result = await remote.fetchProductDetails(productKeys);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
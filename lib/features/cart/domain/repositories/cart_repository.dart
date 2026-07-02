import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Stream<List<CartItem>> cartStream();

  Future<Either<Failure, void>> updateQuantity({
    required String productKey,
    required int quantity,
  });

  Future<Either<Failure, void>> changeSize({
    required String productKey,
    required String size,
    required String price,
  });

  Future<Either<Failure, void>> removeItem(String productKey);

  Future<Either<Failure, void>> clearCart();

  Future<Either<Failure, void>> addOrUpdateItem({
    required String productKey,
    required String name,
    required String imageUrl,
    required String size,
    required String price,
  });

  Future<Either<Failure, Map<String, Map<String, dynamic>?>>> fetchProductDetails(
    List<String> productKeys,
  );
}

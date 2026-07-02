import 'package:dartz/dartz.dart';
import 'package:c_h_p/core/error/failures.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<String>>> fetchCartItemNames() async {
    try {
      final names = await remoteDataSource.fetchCartItemNames();
      return Right(names);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> saveOrder({
    required String paymentId,
    String? signature,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
    required List<String> items,
  }) async {
    try {
      final orderId = await remoteDataSource.saveOrder(
        paymentId: paymentId,
        signature: signature,
        totalAmountPaise: totalAmountPaise,
        deliveryAddress: deliveryAddress,
        lat: lat,
        lng: lng,
        fullName: fullName,
        email: email,
        phone: phone,
        items: items,
      );
      return Right(orderId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPurchaseNotifications({
    required List<String> productNames,
    required int totalAmountPaise,
    String? deliveryAddress,
    double? lat,
    double? lng,
    String? fullName,
    String? email,
    String? phone,
  }) async {
    try {
      await remoteDataSource.sendPurchaseNotifications(
        productNames: productNames,
        totalAmountPaise: totalAmountPaise,
        deliveryAddress: deliveryAddress,
        lat: lat,
        lng: lng,
        fullName: fullName,
        email: email,
        phone: phone,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/handle_payment_success.dart';
import 'payment_state.dart';
import 'payment_notifier.dart';

final _paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl(
    db: FirebaseDatabase.instance,
    auth: FirebaseAuth.instance,
  );
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dataSource = ref.read(_paymentRemoteDataSourceProvider);
  return PaymentRepositoryImpl(dataSource);
});

final handlePaymentSuccessUseCaseProvider = Provider<HandlePaymentSuccess>((ref) {
  return HandlePaymentSuccess(ref.read(paymentRepositoryProvider));
});

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(
    handlePaymentSuccessUseCase: ref.read(handlePaymentSuccessUseCaseProvider),
  );
});

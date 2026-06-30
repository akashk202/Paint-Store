import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/checkout_remote_datasource.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../domain/usecases/fetch_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'checkout_state.dart';
import 'checkout_notifier.dart';

final _checkoutRemoteDataSourceProvider =
    Provider<CheckoutRemoteDataSource>((ref) {
  return CheckoutRemoteDataSourceImpl(
    db: FirebaseDatabase.instance,
    auth: FirebaseAuth.instance,
  );
});

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  final dataSource = ref.read(_checkoutRemoteDataSourceProvider);
  return CheckoutRepositoryImpl(dataSource);
});

final checkoutFetchUserProfileUseCaseProvider =
    Provider<FetchUserProfile>((ref) {
  return FetchUserProfile(ref.read(checkoutRepositoryProvider));
});

final checkoutUpdateUserProfileUseCaseProvider =
    Provider<UpdateUserProfile>((ref) {
  return UpdateUserProfile(ref.read(checkoutRepositoryProvider));
});

final checkoutNotifierProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(
    fetchUserProfile: ref.read(checkoutFetchUserProfileUseCaseProvider),
    updateUserProfile: ref.read(checkoutUpdateUserProfileUseCaseProvider),
  );
});

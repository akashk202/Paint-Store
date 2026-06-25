import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_all_home_products.dart';
import '../../domain/usecases/observe_unread_notifications.dart';
import 'home_state.dart';
import 'home_notifier.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(database: FirebaseDatabase.instance);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.read(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource);
});

final getAllHomeProductsUseCaseProvider = Provider<GetAllHomeProducts>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetAllHomeProducts(repository);
});

final observeUnreadNotificationsUseCaseProvider =
    Provider<ObserveUnreadNotifications>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return ObserveUnreadNotifications(repository);
});

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    getAllHomeProducts: ref.read(getAllHomeProductsUseCaseProvider),
    observeUnreadNotifications: ref.read(observeUnreadNotificationsUseCaseProvider),
  );
});

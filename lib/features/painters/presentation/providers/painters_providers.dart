import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../data/datasources/painters_remote_datasource.dart';
import '../../data/repositories/painters_repository_impl.dart';
import '../../domain/repositories/painters_repository.dart';
import '../../domain/usecases/painters_usecases.dart';
import 'painters_notifier.dart';

final _paintersRemoteDataSourceProvider = Provider<PaintersRemoteDataSource>((ref) {
  return PaintersRemoteDataSourceImpl(FirebaseDatabase.instance.ref());
});

final paintersRepositoryProvider = Provider<PaintersRepository>((ref) {
  return PaintersRepositoryImpl(ref.read(_paintersRemoteDataSourceProvider));
});

final watchPaintersUseCaseProvider = Provider<WatchPainters>((ref) {
  return WatchPainters(ref.read(paintersRepositoryProvider));
});

final paintersNotifierProvider =
    StateNotifierProvider<PaintersNotifier, PaintersState>((ref) {
  return PaintersNotifier(
    watchPainters: ref.read(watchPaintersUseCaseProvider),
  );
});

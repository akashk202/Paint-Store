import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_notifier.dart';

// Provides the Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseDatabaseProvider = Provider<DatabaseReference>((ref) {
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://smart-paint-shop-default-rtdb.firebaseio.com',
  ).ref();
});

// Provides the Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final dbRef = ref.watch(firebaseDatabaseProvider);
  return AuthRemoteDataSource(auth, dbRef);
});

// Provides the Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Notifier
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});

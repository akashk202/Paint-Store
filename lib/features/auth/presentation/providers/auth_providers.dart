import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_notifier.dart';

// Provides the Firebase instances
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseDatabaseProvider = Provider<DatabaseReference>((ref) {
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://smart-paint-shop-default-rtdb.firebaseio.com',
  ).ref();
});

// Provides the Data Source (Private to avoid presentation layer bypassing repository)
final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final dbRef = ref.watch(firebaseDatabaseProvider);
  return AuthRemoteDataSourceImpl(auth: auth, dbRef: dbRef);
});

// Provides the Repository (Private, as presentation layer should interact via UseCases)
final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(_authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Provides Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(_authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(_authRepositoryProvider));
});

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  return GoogleSignInUseCase(ref.watch(_authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(_authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(_authRepositoryProvider));
});

// Notifier
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});


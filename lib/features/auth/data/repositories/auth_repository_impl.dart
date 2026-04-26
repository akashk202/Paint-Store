import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _remoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) {
    return _remoteDataSource.registerUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      address: address,
    );
  }

  @override
  Future<UserCredential?> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> resetPassword(String email) {
    return _remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }
}

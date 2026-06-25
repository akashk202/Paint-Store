import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  
  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  });
  
  Future<UserCredential?> signInWithGoogle();
  
  Future<void> resetPassword(String email);
  
  Future<void> signOut();
}

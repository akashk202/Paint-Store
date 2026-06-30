import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:c_h_p/core/error/exceptions.dart';
import 'package:c_h_p/core/utils/constants.dart';
import 'package:c_h_p/features/auth/data/models/user_model.dart';
import 'package:c_h_p/firebase_options.dart';
import 'package:c_h_p/features/notifications/data/datasources/fcm_remote_datasource.dart';


/// Contract for the auth remote data source.
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  });
  Future<UserModel> googleSignIn();
  Future<void> resetPassword({required String email});
  Future<void> logout();
  UserModel? getCurrentUser();
}

/// Implementation that wraps Firebase Auth + Firebase Realtime Database.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? auth,
    DatabaseReference? dbRef,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _dbRef = dbRef ??
            FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL: AppConstants.firebaseDatabaseUrl,
            ).ref();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _auth.currentUser;
      if (user == null) {
        throw const AuthException('Login succeeded but no user found');
      }

      // Ensure user record exists in database
      final userRef = _dbRef.child('users').child(user.uid);
      final snap = await userRef.get();

      String userType = AppConstants.defaultUserRole;
      if (!snap.exists) {
        final userData = {
          'uid': user.uid,
          'email': email,
          'userType': userType,
          'status': 'approved',
          'createdAt': DateTime.now().toIso8601String(),
        };
        await userRef.set(userData);
      } else {
        final data = Map<String, dynamic>.from(snap.value as Map);
        userType = (data['userType'] ?? AppConstants.defaultUserRole) as String;
      }

      // Override for admin email
      if (email == AppConstants.adminEmail) {
        userType = 'Admin';
      }

      return UserModel.fromFirebaseUser(
        uid: user.uid,
        email: user.email ?? email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        userType: userType,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code), e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) {
        throw const AuthException('Registration succeeded but no user found');
      }

      await user.updateDisplayName(name);

      final uid = user.uid;
      final userRef = _dbRef.child('users').child(uid);

      // Create main user record
      await userRef.set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'userType': AppConstants.defaultUserRole,
        'status': 'approved',
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Create unified profile node
      await userRef.child('profile').set({
        'fullName': name,
        'phone': phone,
        'email': email,
        'address': address,
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      });

      return UserModel.fromFirebaseUser(
        uid: uid,
        email: email,
        displayName: name,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code), e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> googleSignIn() async {
    try {
      final googleSignInInstance = kIsWeb
          ? GoogleSignIn(clientId: DefaultFirebaseOptions.web.appId)
          : GoogleSignIn();

      await googleSignInInstance.signOut();

      final googleUser = await googleSignInInstance.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled', 'cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException(
            'Google sign-in succeeded but no user found');
      }

      final userRef = _dbRef.child('users').child(user.uid);
      final snapshot = await userRef.get();

      String userType = AppConstants.defaultUserRole;
      if (!snapshot.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'userType': userType,
          'status': 'approved',
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        await userRef.update({
          'name': user.displayName,
          'photoUrl': user.photoURL,
        });
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        userType = (data['userType'] ?? AppConstants.defaultUserRole) as String;
      }

      if (user.email == AppConstants.adminEmail) {
        userType = 'Admin';
      }

      return UserModel.fromFirebaseUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        userType: userType,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google Sign-In failed', e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
          'An unexpected error occurred during Google Sign-In: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code), e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FCMRemoteDataSource.unsubscribeForUser(_auth.currentUser);
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel.fromFirebaseUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  /// Maps Firebase Auth error codes to human-readable messages.
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-email':
        return 'The email address format is not valid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An error occurred. Please check your connection.';
    }
  }
}

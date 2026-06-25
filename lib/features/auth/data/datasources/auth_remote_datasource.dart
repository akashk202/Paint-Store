import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:c_h_p/firebase_options.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final DatabaseReference _dbRef;

  AuthRemoteDataSource(this._auth, this._dbRef);

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    
    // Ensure user record exists for role fetch after login
    try {
      final uid = cred.user?.uid;
      if (uid != null) {
        final userRef = _dbRef.child("users").child(uid);
        final snap = await userRef.get();
        if (!snap.exists) {
          await userRef.set({
            'uid': uid,
            'email': email.trim(),
            'userType': 'Customer',
            'status': 'approved',
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }
    } catch (_) {
      // Ignore database errors during login fallback
    }
    return cred;
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCred.user!.uid;

    await userCred.user!.updateDisplayName(name);

    await _dbRef.child('users').child(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'userType': 'Customer', // All new users are customers
      'status': 'approved',
      'createdAt': DateTime.now().toIso8601String(),
    });
    
    // Initialize unified profile node for autofill & manager views
    await _dbRef.child('users').child(uid).child('profile').set({
      'fullName': name,
      'phone': phone,
      'email': email,
      'address': address,
      'createdAt': ServerValue.timestamp,
      'updatedAt': ServerValue.timestamp,
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = kIsWeb
        ? GoogleSignIn(clientId: DefaultFirebaseOptions.web.appId)
        : GoogleSignIn();

    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;
    
    if (user != null) {
      final userRef = _dbRef.child("users").child(user.uid);
      final snapshot = await userRef.get();

      if (!snapshot.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'userType': 'Customer',
          'status': 'approved',
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        await userRef.update({
          'name': user.displayName,
          'photoUrl': user.photoURL,
        });
      }
    }
    return userCredential;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

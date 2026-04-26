import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  });
  Future<String> updateProfilePicture(File imageFile);
  Future<void> deleteProfilePicture();
  Future<void> updateUserPassword(String currentPassword, String newPassword);
  Future<String> fetchUserRole(String uid);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth auth;
  final DatabaseReference dbRef;
  final FirebaseStorage storage;

  UserRemoteDataSourceImpl({
    required this.auth,
    required this.dbRef,
    required this.storage,
  });

  @override
  Future<UserProfileModel> getUserProfile() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final snapshot = await dbRef.child('users/${user.uid}').get();
    Map<String, dynamic> data = {};
    if (snapshot.exists && snapshot.value != null) {
      data = Map<String, dynamic>.from(snapshot.value as Map);
    }

    return UserProfileModel.fromFirebaseMap(
      user.uid,
      user.email ?? '',
      user.displayName,
      user.photoURL,
      data,
    );
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String address,
    required String pincode,
    double? lat,
    double? lng,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in.');

    await user.updateDisplayName(name);
    await dbRef.child('users/${user.uid}').update({
      "name": name,
      "pincode": pincode,
    });
    
    await dbRef.child('users/${user.uid}/profile').update({
      'fullName': name,
      'phone': phone,
      'email': user.email ?? '',
      'address': address,
      if (lat != null && lng != null) 'location': {'lat': lat, 'lng': lng},
      'updatedAt': ServerValue.timestamp,
    });
  }

  @override
  Future<String> updateProfilePicture(File imageFile) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in.');

    final ref = storage.ref().child("profile_pictures").child(user.uid).child("profile.jpg");
    await ref.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
    
    final url = await ref.getDownloadURL();
    await user.updatePhotoURL(url);
    await dbRef.child('users/${user.uid}').update({"photoUrl": url});
    
    return url;
  }

  @override
  Future<void> deleteProfilePicture() async {
    final user = auth.currentUser;
    if (user == null || user.photoURL == null) return;

    try {
      final ref = storage.refFromURL(user.photoURL!);
      await ref.delete();
    } catch (_) {
      // Might already be deleted or invalid URL
    }
    await user.updatePhotoURL(null);
    await dbRef.child('users/${user.uid}').update({"photoUrl": null});
  }

  @override
  Future<void> updateUserPassword(String currentPassword, String newPassword) async {
    final user = auth.currentUser;
    if (user == null) throw Exception('User not logged in.');
    if (user.email == null) throw Exception('User email not found.');

    final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  @override
  Future<String> fetchUserRole(String uid) async {
    try {
      final snap = await dbRef.child('users/$uid').get();
      if (!snap.exists || snap.value == null) return 'Customer';
      final map = Map<String, dynamic>.from(snap.value as Map);
      final role = (map['userType'] ?? 'Customer').toString();
      return role.isEmpty ? 'Customer' : role;
    } catch (_) {
      return 'Customer';
    }
  }
}

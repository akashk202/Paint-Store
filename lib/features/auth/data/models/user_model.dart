import 'package:c_h_p/features/auth/domain/entities/user_entity.dart';

/// Data model that extends [UserEntity] and adds serialization.
/// This bridges Firebase data and the domain layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.name,
    super.photoUrl,
    super.userType,
    super.status,
  });

  /// Create from a Firebase Realtime Database snapshot map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      name: map['name'] as String?,
      photoUrl: map['photoUrl'] as String?,
      userType: (map['userType'] ?? 'Customer') as String,
      status: (map['status'] ?? 'approved') as String,
    );
  }

  /// Create from a Firebase Auth [User] object and optional DB data.
  factory UserModel.fromFirebaseUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String userType = 'Customer',
    String status = 'approved',
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: displayName,
      photoUrl: photoURL,
      userType: userType,
      status: status,
    );
  }

  /// Convert to a map for Firebase Realtime Database.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'userType': userType,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Create a copy with optional overrides.
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    String? userType,
    String? status,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      userType: userType ?? this.userType,
      status: status ?? this.status,
    );
  }
}

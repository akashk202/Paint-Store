import 'dart:io';

class UserProfileEntity {
  final String uid;
  final String email;
  final String role;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final String? address;
  final String? pincode;
  final double? lat;
  final double? lng;

  const UserProfileEntity({
    required this.uid,
    required this.email,
    this.role = 'Customer',
    this.displayName,
    this.photoUrl,
    this.phone,
    this.address,
    this.pincode,
    this.lat,
    this.lng,
  });

  UserProfileEntity copyWith({
    String? uid,
    String? email,
    String? role,
    String? displayName,
    String? photoUrl,
    String? phone,
    String? address,
    String? pincode,
    double? lat,
    double? lng,
  }) {
    return UserProfileEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

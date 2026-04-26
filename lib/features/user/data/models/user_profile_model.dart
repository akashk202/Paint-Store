import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.email,
    super.role = 'Customer',
    super.displayName,
    super.photoUrl,
    super.phone,
    super.address,
    super.pincode,
    super.lat,
    super.lng,
  });

  factory UserProfileModel.fromFirebaseMap(String uid, String email, String? displayName, String? photoUrl, Map<String, dynamic> data) {
    String role = 'Customer';
    if (data['userType'] != null) {
      role = data['userType'].toString();
      if (role.isEmpty) role = 'Customer';
    }

    String? phone;
    String? address;
    double? lat;
    double? lng;

    if (data.containsKey('profile') && data['profile'] is Map) {
      final p = Map<String, dynamic>.from(data['profile']);
      phone = p['phone']?.toString();
      address = p['address']?.toString();
      if (p['location'] is Map) {
        final loc = Map<String, dynamic>.from(p['location']);
        lat = (loc['lat'] as num?)?.toDouble();
        lng = (loc['lng'] as num?)?.toDouble();
      }
    } else {
      phone = data['phone']?.toString();
      address = data['address']?.toString();
    }

    return UserProfileModel(
      uid: uid,
      email: email,
      role: role,
      displayName: displayName,
      photoUrl: photoUrl,
      phone: phone,
      address: address,
      pincode: data['pincode']?.toString(),
      lat: lat,
      lng: lng,
    );
  }
}

import '../core/enums/user_role.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.role,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profile_image'] as String,
      role: UserRole.values.byName(json['role'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String id;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  final String profileImage;
  final UserRole role;
  final double latitude;
  final double longitude;
  final bool isActive;
  final DateTime createdAt;

  String get fullName => '$name $lastName'.trim();

  UserModel copyWith({
    String? id,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    UserRole? role,
    double? latitude,
    double? longitude,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': name,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'role': role.name,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

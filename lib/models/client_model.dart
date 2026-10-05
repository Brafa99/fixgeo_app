import '../core/enums/user_role.dart';
import 'user_model.dart';

class ClientModel extends UserModel {
  const ClientModel({
    required super.id,
    required super.name,
    required super.lastName,
    required super.email,
    required super.phone,
    required super.profileImage,
    required super.latitude,
    required super.longitude,
    required this.address,
    required super.isActive,
    required super.createdAt,
  }) : super(role: UserRole.client);

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      name: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profile_image'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String address;

  @override
  ClientModel copyWith({
    String? id,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    UserRole? role,
    double? latitude,
    double? longitude,
    String? address,
    bool? isActive,
    DateTime? createdAt,
  }) {
    assert(role == null || role == UserRole.client);
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'address': address,
    };
  }
}

import '../core/enums/user_role.dart';
import 'user_model.dart';

class WorkerModel extends UserModel {
  const WorkerModel({
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
    required this.isAvailable,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.description,
    required this.coverageRadiusKm,
    required this.serviceIds,
    required super.createdAt,
  }) : super(role: UserRole.worker);

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
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
      isAvailable: json['is_available'] as bool,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      experience: json['experience'] as int,
      description: json['description'] as String,
      coverageRadiusKm: (json['coverage_radius_km'] as num).toDouble(),
      serviceIds: List<String>.from(json['service_ids'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String address;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final int experience;
  final String description;
  final double coverageRadiusKm;
  final List<String> serviceIds;

  @override
  WorkerModel copyWith({
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
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    int? experience,
    String? description,
    double? coverageRadiusKm,
    List<String>? serviceIds,
    DateTime? createdAt,
  }) {
    assert(role == null || role == UserRole.worker);
    return WorkerModel(
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
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      coverageRadiusKm: coverageRadiusKm ?? this.coverageRadiusKm,
      serviceIds: List.unmodifiable(serviceIds ?? this.serviceIds),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'address': address,
      'is_available': isAvailable,
      'rating': rating,
      'review_count': reviewCount,
      'experience': experience,
      'description': description,
      'coverage_radius_km': coverageRadiusKm,
      'service_ids': serviceIds,
    };
  }
}

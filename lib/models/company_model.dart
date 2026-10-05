import '../core/enums/user_role.dart';
import 'user_model.dart';

class CompanyModel extends UserModel {
  const CompanyModel({
    required super.id,
    required this.legalName,
    required this.commercialName,
    required super.email,
    required super.phone,
    required this.logo,
    required this.address,
    required super.latitude,
    required super.longitude,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required super.isActive,
    required this.serviceIds,
    required super.createdAt,
  }) : super(
          name: commercialName,
          lastName: '',
          profileImage: logo,
          role: UserRole.company,
        );

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      legalName: json['legal_name'] as String,
      commercialName: json['commercial_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      logo: json['logo'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      isActive: json['is_active'] as bool,
      serviceIds: List<String>.from(json['service_ids'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String legalName;
  final String commercialName;
  final String logo;
  final String address;
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> serviceIds;

  @override
  CompanyModel copyWith({
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
    String? legalName,
    String? commercialName,
    String? logo,
    String? address,
    String? description,
    double? rating,
    int? reviewCount,
    List<String>? serviceIds,
  }) {
    assert(role == null || role == UserRole.company);
    assert(lastName == null || lastName.isEmpty);
    return CompanyModel(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      commercialName: commercialName ?? name ?? this.commercialName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      logo: logo ?? profileImage ?? this.logo,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isActive: isActive ?? this.isActive,
      serviceIds: List.unmodifiable(serviceIds ?? this.serviceIds),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'legal_name': legalName,
      'commercial_name': commercialName,
      'logo': logo,
      'address': address,
      'description': description,
      'rating': rating,
      'review_count': reviewCount,
      'service_ids': serviceIds,
    };
  }
}

import '../core/enums/provider_type.dart';
import '../core/enums/service_request_status.dart';

class ServiceRequestModel {
  const ServiceRequestModel({
    required this.id,
    required this.clientId,
    required this.serviceId,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledFor,
    this.selectedProviderId,
    this.selectedProviderType,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    final providerType = json['selected_provider_type'] as String?;
    return ServiceRequestModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      serviceId: json['service_id'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      images: List<String>.from(json['images'] as List),
      status: ServiceRequestStatus.values.byName(json['status'] as String),
      selectedProviderId: json['selected_provider_id'] as String?,
      selectedProviderType: providerType == null
          ? null
          : ProviderType.values.byName(providerType),
      scheduledFor: json['scheduled_for'] == null
          ? null
          : DateTime.parse(json['scheduled_for'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String clientId;
  final String serviceId;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> images;
  final ServiceRequestStatus status;
  final DateTime? scheduledFor;
  final String? selectedProviderId;
  final ProviderType? selectedProviderType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceRequestModel copyWith({
    String? id,
    String? clientId,
    String? serviceId,
    String? description,
    double? latitude,
    double? longitude,
    String? address,
    List<String>? images,
    ServiceRequestStatus? status,
    DateTime? scheduledFor,
    bool clearScheduledFor = false,
    String? selectedProviderId,
    ProviderType? selectedProviderType,
    bool clearSelectedProvider = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceRequestModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      serviceId: serviceId ?? this.serviceId,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      images: List.unmodifiable(images ?? this.images),
      status: status ?? this.status,
      scheduledFor:
          clearScheduledFor ? null : scheduledFor ?? this.scheduledFor,
      selectedProviderId: clearSelectedProvider
          ? null
          : selectedProviderId ?? this.selectedProviderId,
      selectedProviderType: clearSelectedProvider
          ? null
          : selectedProviderType ?? this.selectedProviderType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'service_id': serviceId,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'images': images,
      'status': status.name,
      'scheduled_for': scheduledFor?.toIso8601String(),
      'selected_provider_id': selectedProviderId,
      'selected_provider_type': selectedProviderType?.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

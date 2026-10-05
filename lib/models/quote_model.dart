import '../core/enums/provider_type.dart';
import '../core/enums/quote_status.dart';

class QuoteModel {
  const QuoteModel({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.providerType,
    required this.laborCost,
    required this.materialsCost,
    required this.total,
    required this.estimatedTime,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      providerId: json['provider_id'] as String,
      providerType: ProviderType.values.byName(json['provider_type'] as String),
      laborCost: (json['labor_cost'] as num).toDouble(),
      materialsCost: (json['materials_cost'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      estimatedTime: Duration(minutes: json['estimated_time_minutes'] as int),
      notes: json['notes'] as String,
      status: QuoteStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String id;
  final String requestId;
  final String providerId;
  final ProviderType providerType;
  final double laborCost;
  final double materialsCost;
  final double total;
  final Duration estimatedTime;
  final String notes;
  final QuoteStatus status;
  final DateTime createdAt;

  QuoteModel copyWith({
    String? id,
    String? requestId,
    String? providerId,
    ProviderType? providerType,
    double? laborCost,
    double? materialsCost,
    double? total,
    Duration? estimatedTime,
    String? notes,
    QuoteStatus? status,
    DateTime? createdAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      providerId: providerId ?? this.providerId,
      providerType: providerType ?? this.providerType,
      laborCost: laborCost ?? this.laborCost,
      materialsCost: materialsCost ?? this.materialsCost,
      total: total ?? this.total,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'provider_id': providerId,
      'provider_type': providerType.name,
      'labor_cost': laborCost,
      'materials_cost': materialsCost,
      'total': total,
      'estimated_time_minutes': estimatedTime.inMinutes,
      'notes': notes,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

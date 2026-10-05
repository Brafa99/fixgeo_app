class ReviewModel {
  const ReviewModel({
    required this.id,
    required this.providerId,
    required this.clientId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      clientId: json['client_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final String id;
  final String providerId;
  final String clientId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider_id': providerId,
        'client_id': clientId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };
}

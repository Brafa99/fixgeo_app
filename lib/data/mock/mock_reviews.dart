import '../../models/review_model.dart';

final List<ReviewModel> mockReviews = List.unmodifiable([
  ReviewModel(
    id: 'review_001',
    providerId: 'worker_001',
    clientId: 'client_001',
    rating: 5,
    comment:
        'Muy buen trabajo. Llegó puntual y solucionó el problema rápidamente.',
    createdAt: DateTime.utc(2026, 3, 22, 14, 30),
  ),
  ReviewModel(
    id: 'review_002',
    providerId: 'worker_001',
    clientId: 'client_002',
    rating: 4.7,
    comment: 'Excelente atención, explicó el trabajo y dejó todo ordenado.',
    createdAt: DateTime.utc(2026, 3, 14, 16),
  ),
  ReviewModel(
    id: 'review_003',
    providerId: 'worker_005',
    clientId: 'client_003',
    rating: 4.9,
    comment: 'Trabajo rápido y muy profesional. Lo volvería a contratar.',
    createdAt: DateTime.utc(2026, 3, 19, 12, 15),
  ),
  ReviewModel(
    id: 'review_004',
    providerId: 'company_001',
    clientId: 'client_004',
    rating: 4.8,
    comment: 'La empresa respondió rápido y coordinó muy bien la visita.',
    createdAt: DateTime.utc(2026, 3, 17, 10, 45),
  ),
  ReviewModel(
    id: 'review_005',
    providerId: 'company_001',
    clientId: 'client_005',
    rating: 4.6,
    comment: 'Buen servicio y comunicación clara durante todo el trabajo.',
    createdAt: DateTime.utc(2026, 3, 8, 18, 20),
  ),
]);

import '../models/review_model.dart';

abstract interface class ReviewRepository {
  Future<List<ReviewModel>> getReviewsByProvider(String providerId);
}

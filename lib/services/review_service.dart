import '../models/review_model.dart';
import '../repositories/review_repository.dart';

class ReviewService {
  const ReviewService(this._repository);

  final ReviewRepository _repository;

  Future<List<ReviewModel>> getReviewsByProvider(String providerId) =>
      _repository.getReviewsByProvider(providerId);
}

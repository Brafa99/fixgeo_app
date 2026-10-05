import '../../../models/review_model.dart';
import '../../../repositories/review_repository.dart';
import '../mock_reviews.dart';

class MockReviewRepository implements ReviewRepository {
  MockReviewRepository({List<ReviewModel>? reviews})
      : _reviews = List.unmodifiable(reviews ?? mockReviews);

  final List<ReviewModel> _reviews;

  @override
  Future<List<ReviewModel>> getReviewsByProvider(String providerId) async {
    final reviews = _reviews
        .where((review) => review.providerId == providerId)
        .toList(growable: false)
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
    return List.unmodifiable(reviews);
  }
}

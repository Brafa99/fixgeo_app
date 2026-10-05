import '../../../models/review_model.dart';

class ProviderReviewItem {
  const ProviderReviewItem({
    required this.review,
    required this.clientName,
  });

  final ReviewModel review;
  final String clientName;
}

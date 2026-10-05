import '../../models/review_model.dart';
import '../../repositories/review_repository.dart';

class SupabaseReviewRepository implements ReviewRepository {
  // TODO: Inject SupabaseClient and query reviews by provider_id.
  @override
  Future<List<ReviewModel>> getReviewsByProvider(String providerId) =>
      throw UnimplementedError();
}

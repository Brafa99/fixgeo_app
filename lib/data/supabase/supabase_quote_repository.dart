import '../../models/quote_model.dart';
import '../../repositories/quote_repository.dart';

class SupabaseQuoteRepository implements QuoteRepository {
  // TODO: Inject a Supabase client and persist quote.toJson() rows.

  @override
  Future<QuoteModel> createQuote(QuoteModel quote) =>
      throw UnimplementedError();

  @override
  Future<QuoteModel?> getQuoteById(String id) => throw UnimplementedError();

  @override
  Future<List<QuoteModel>> getQuotes() => throw UnimplementedError();

  @override
  Future<List<QuoteModel>> getQuotesByProvider(String providerId) =>
      throw UnimplementedError();

  @override
  Future<List<QuoteModel>> getQuotesByRequest(String requestId) =>
      throw UnimplementedError();

  @override
  Future<QuoteModel> updateQuote(QuoteModel quote) =>
      throw UnimplementedError();
}

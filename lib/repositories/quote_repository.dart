import '../models/quote_model.dart';

abstract interface class QuoteRepository {
  Future<List<QuoteModel>> getQuotes();

  Future<QuoteModel?> getQuoteById(String id);

  Future<List<QuoteModel>> getQuotesByRequest(String requestId);

  Future<List<QuoteModel>> getQuotesByProvider(String providerId);

  Future<QuoteModel> createQuote(QuoteModel quote);

  Future<QuoteModel> updateQuote(QuoteModel quote);
}

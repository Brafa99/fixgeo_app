import '../models/quote_model.dart';
import '../repositories/quote_repository.dart';

class QuoteService {
  const QuoteService(this._repository);

  final QuoteRepository _repository;

  Future<List<QuoteModel>> getQuotes() => _repository.getQuotes();

  Future<QuoteModel?> getQuoteById(String id) => _repository.getQuoteById(id);

  Future<List<QuoteModel>> getQuotesByRequest(String requestId) =>
      _repository.getQuotesByRequest(requestId);

  Future<List<QuoteModel>> getQuotesByProvider(String providerId) =>
      _repository.getQuotesByProvider(providerId);

  Future<QuoteModel> createQuote(QuoteModel quote) =>
      _repository.createQuote(quote);

  Future<QuoteModel> updateQuote(QuoteModel quote) =>
      _repository.updateQuote(quote);
}

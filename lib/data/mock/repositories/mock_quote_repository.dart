import '../../../models/quote_model.dart';
import '../../../repositories/quote_repository.dart';
import '../mock_quotes.dart';

class MockQuoteRepository implements QuoteRepository {
  MockQuoteRepository({List<QuoteModel>? quotes})
      : _quotes = List.of(quotes ?? mockQuotes);

  final List<QuoteModel> _quotes;

  @override
  Future<QuoteModel> createQuote(QuoteModel quote) async {
    if (_quotes.any((current) => current.id == quote.id)) {
      throw StateError('A quote with id ${quote.id} already exists.');
    }
    _quotes.add(quote);
    return quote;
  }

  @override
  Future<QuoteModel?> getQuoteById(String id) async {
    for (final quote in _quotes) {
      if (quote.id == id) return quote;
    }
    return null;
  }

  @override
  Future<List<QuoteModel>> getQuotes() async => List.unmodifiable(_quotes);

  @override
  Future<List<QuoteModel>> getQuotesByProvider(String providerId) async {
    return List.unmodifiable(
      _quotes.where((quote) => quote.providerId == providerId),
    );
  }

  @override
  Future<List<QuoteModel>> getQuotesByRequest(String requestId) async {
    return List.unmodifiable(
      _quotes.where((quote) => quote.requestId == requestId),
    );
  }

  @override
  Future<QuoteModel> updateQuote(QuoteModel quote) async {
    final index = _quotes.indexWhere((current) => current.id == quote.id);
    if (index == -1) {
      throw StateError('Quote ${quote.id} does not exist.');
    }
    _quotes[index] = quote;
    return quote;
  }
}

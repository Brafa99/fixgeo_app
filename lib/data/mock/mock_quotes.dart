import '../../core/enums/provider_type.dart';
import '../../core/enums/quote_status.dart';
import '../../models/quote_model.dart';

final List<QuoteModel> mockQuotes = List.unmodifiable([
  QuoteModel(
    id: 'quote_001',
    requestId: 'request_001',
    providerId: 'worker_001',
    providerType: ProviderType.worker,
    laborCost: 120,
    materialsCost: 45,
    total: 165,
    estimatedTime: const Duration(hours: 2),
    notes: 'Incluye el cambio de empaques y la instalación de la mezcladora.',
    status: QuoteStatus.pending,
    createdAt: DateTime.utc(2026, 3, 18, 14, 5),
  ),
  QuoteModel(
    id: 'quote_002',
    requestId: 'request_002',
    providerId: 'company_001',
    providerType: ProviderType.company,
    laborCost: 180,
    materialsCost: 70,
    total: 250,
    estimatedTime: const Duration(hours: 3),
    notes: 'Se revisará el circuito y se reemplazarán los dos tomacorrientes.',
    status: QuoteStatus.accepted,
    createdAt: DateTime.utc(2026, 3, 20, 16, 35),
  ),
  QuoteModel(
    id: 'quote_003',
    requestId: 'request_004',
    providerId: 'company_002',
    providerType: ProviderType.company,
    laborCost: 320,
    materialsCost: 55,
    total: 375,
    estimatedTime: const Duration(hours: 6),
    notes: 'Incluye insumos de limpieza y un equipo de dos personas.',
    status: QuoteStatus.accepted,
    createdAt: DateTime.utc(2026, 3, 10, 15, 20),
  ),
]);

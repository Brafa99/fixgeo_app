import '../../core/enums/provider_type.dart';
import '../../core/enums/service_request_status.dart';
import '../../models/service_request_model.dart';

DateTime _minutesAgo(int minutes) =>
    DateTime.now().subtract(Duration(minutes: minutes));

DateTime _hoursAgo(int hours) =>
    DateTime.now().subtract(Duration(hours: hours));

DateTime _daysAgo(int days) =>
    DateTime.now().subtract(Duration(days: days));

DateTime _todayAfternoon() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 16, 0);
}

DateTime _tomorrowMorning() {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0);
}

final List<ServiceRequestModel> mockRequests = List.unmodifiable([
  // Pedido 1: Plomería, Lucía Fernández, NUEVA (pending), ~0.8 km, Lo antes posible, Hace 5 min
  ServiceRequestModel(
    id: 'request_001',
    clientId: 'client_001',
    serviceId: 'service_plumbing',
    description:
        'Tengo una fuga debajo del lavamanos y se está filtrando agua.',
    latitude: -16.5065,
    longitude: -68.1440,
    address: 'Calle Pedro Salazar 612, Sopocachi, La Paz',
    images: const ['https://cdn.fixgeo.example/requests/request_001_1.jpg'],
    status: ServiceRequestStatus.pending,
    scheduledFor: null,
    selectedProviderId: null,
    selectedProviderType: null,
    createdAt: _minutesAgo(5),
    updatedAt: _minutesAgo(5),
  ),

  // Pedido 2: Electricidad, Diego Vargas, NUEVA (pending), ~1.4 km, Hoy por la tarde, Hace 20 min
  ServiceRequestModel(
    id: 'request_002',
    clientId: 'client_002',
    serviceId: 'service_electricity',
    description: 'Necesito revisar una toma que dejó de funcionar.',
    latitude: -16.5100,
    longitude: -68.1398,
    address: 'Avenida 20 de Octubre 2148, Sopocachi, La Paz',
    images: const [],
    status: ServiceRequestStatus.pending,
    scheduledFor: _todayAfternoon(),
    selectedProviderId: null,
    selectedProviderType: null,
    createdAt: _minutesAgo(20),
    updatedAt: _minutesAgo(20),
  ),

  // Pedido 3: Plomería, Mariana Quiroga, ACEPTADA (accepted por Carlos Mendoza), ~2.1 km, Mañana 10:00, Hace 1 h
  ServiceRequestModel(
    id: 'request_003',
    clientId: 'client_003',
    serviceId: 'service_plumbing',
    description: 'Revisión general del sistema de agua en la casa.',
    latitude: -16.4875,
    longitude: -68.1628,
    address: 'Calle Ecuador 1881, San Pedro, La Paz',
    images: const [],
    status: ServiceRequestStatus.accepted,
    scheduledFor: _tomorrowMorning(),
    selectedProviderId: 'worker_001',
    selectedProviderType: ProviderType.worker,
    createdAt: _hoursAgo(1),
    updatedAt: _hoursAgo(1),
  ),

  // Pedido 4: Pintura (Carlos no ofrece pintura -> filtrado)
  ServiceRequestModel(
    id: 'request_004',
    clientId: 'client_004',
    serviceId: 'service_painting',
    description: 'Quiero pintar una habitación de cuatro por tres metros.',
    latitude: -16.4950,
    longitude: -68.1395,
    address: 'Calle Ecuador 1881, San Pedro, La Paz',
    images: const ['https://cdn.fixgeo.example/requests/request_003_1.jpg'],
    status: ServiceRequestStatus.pending,
    scheduledFor: null,
    selectedProviderId: null,
    selectedProviderType: null,
    createdAt: _daysAgo(1),
    updatedAt: _daysAgo(1),
  ),

  // Pedido 5: Plomería fuera del radio de 5 km (~7.5 km de Carlos -> filtrado por radio)
  ServiceRequestModel(
    id: 'request_005',
    clientId: 'client_005',
    serviceId: 'service_plumbing',
    description: 'Instalación de lavadora y cambio de grifo en patio.',
    latitude: -16.5680,
    longitude: -68.1490,
    address: 'Calle 21 de Calacoto 780, La Paz',
    images: const [],
    status: ServiceRequestStatus.pending,
    scheduledFor: null,
    selectedProviderId: null,
    selectedProviderType: null,
    createdAt: _hoursAgo(2),
    updatedAt: _hoursAgo(2),
  ),

  // Pedido 6: Electricidad asignado a otro trabajador (worker_002 -> no aparece como nueva para Carlos)
  ServiceRequestModel(
    id: 'request_006',
    clientId: 'client_002',
    serviceId: 'service_electricity',
    description: 'Instalación de luminaria en sala principal.',
    latitude: -16.5032,
    longitude: -68.1475,
    address: 'Avenida 20 de Octubre 2148, Sopocachi, La Paz',
    images: const [],
    status: ServiceRequestStatus.accepted,
    scheduledFor: null,
    selectedProviderId: 'worker_002',
    selectedProviderType: ProviderType.worker,
    createdAt: _hoursAgo(3),
    updatedAt: _hoursAgo(2),
  ),
]);

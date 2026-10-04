import '../../../core/constants/app_assets.dart';
import '../models/provider_preview.dart';
import '../models/request_preview.dart';
import '../models/service_category.dart';

abstract final class HomeMockData {
  static const categories = <ServiceCategory>[
    ServiceCategory(
      id: 'gardening',
      name: 'Jardinería',
      image: AppAssets.categoryGardening,
    ),
    ServiceCategory(
      id: 'moving',
      name: 'Flete / Mudanza',
      image: AppAssets.categoryMoving,
    ),
    ServiceCategory(
      id: 'plumbing',
      name: 'Plomería',
      image: AppAssets.categoryPlumbing,
    ),
    ServiceCategory(
      id: 'electricity',
      name: 'Electricidad',
      image: AppAssets.categoryElectricity,
    ),
    ServiceCategory(
      id: 'painting',
      name: 'Pintura',
      image: AppAssets.categoryPainting,
    ),
    ServiceCategory(
      id: 'cleaning',
      name: 'Limpieza',
      image: AppAssets.categoryCleaning,
    ),
    ServiceCategory(
      id: 'masonry',
      name: 'Albañilería',
      image: AppAssets.categoryMasonry,
    ),
    ServiceCategory(
      id: 'more',
      name: 'Más categorías',
      image: AppAssets.categoryMore,
    ),
  ];

  static const providers = <ProviderPreview>[
    ProviderPreview(
      id: 'provider-1',
      name: 'Marcos López',
      specialty: 'Electricista',
      rating: 4.9,
      distance: '1.2 km',
      priceFrom: 'Bs 80',
      avatar: AppAssets.provider,
    ),
    ProviderPreview(
      id: 'provider-2',
      name: 'Andrea Rojas',
      specialty: 'Pintura',
      rating: 4.8,
      distance: '2.4 km',
      priceFrom: 'Bs 100',
      avatar: AppAssets.client,
    ),
    ProviderPreview(
      id: 'provider-3',
      name: 'Carlos Mendoza',
      specialty: 'Plomería',
      rating: 4.7,
      distance: '3.1 km',
      priceFrom: 'Bs 90',
      avatar: AppAssets.provider,
    ),
  ];

  static const requests = <RequestPreview>[
    RequestPreview(
      id: 'request-1',
      title: 'Reparación de ducha',
      status: RequestStatus.pending,
      date: 'Hoy',
    ),
    RequestPreview(
      id: 'request-2',
      title: 'Pintar habitación',
      status: RequestStatus.inProgress,
      date: 'Ayer',
    ),
    RequestPreview(
      id: 'request-3',
      title: 'Instalación de lámpara',
      status: RequestStatus.completed,
      date: '12 sep',
    ),
  ];
}

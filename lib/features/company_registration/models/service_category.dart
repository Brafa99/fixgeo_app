import '../../../core/constants/app_assets.dart';

class CompanyServiceCategory {
  const CompanyServiceCategory({
    required this.id,
    required this.name,
    required this.asset,
  });

  final String id;
  final String name;
  final String asset;
}

abstract final class CompanyServiceCategories {
  static const all = <CompanyServiceCategory>[
    CompanyServiceCategory(
      id: 'masonry',
      name: 'Albañilería',
      asset: AppAssets.workerMasonry,
    ),
    CompanyServiceCategory(
      id: 'electricity',
      name: 'Electricidad',
      asset: AppAssets.workerElectricity,
    ),
    CompanyServiceCategory(
      id: 'painting',
      name: 'Pintura',
      asset: AppAssets.workerPainting,
    ),
    CompanyServiceCategory(
      id: 'plumbing',
      name: 'Plomería',
      asset: AppAssets.workerPlumbing,
    ),
    CompanyServiceCategory(
      id: 'air-conditioning',
      name: 'Aire acondicionado',
      asset: AppAssets.workerAirConditioning,
    ),
    CompanyServiceCategory(
      id: 'gardening',
      name: 'Jardinería',
      asset: AppAssets.workerGardening,
    ),
    CompanyServiceCategory(
      id: 'moving',
      name: 'Flete / Mudanza',
      asset: AppAssets.workerMoving,
    ),
    CompanyServiceCategory(
      id: 'security',
      name: 'Seguridad',
      asset: AppAssets.workerSecurity,
    ),
    CompanyServiceCategory(
      id: 'carpentry',
      name: 'Carpintería',
      asset: AppAssets.workerCarpentry,
    ),
    CompanyServiceCategory(
      id: 'cleaning',
      name: 'Limpieza',
      asset: AppAssets.workerCleaning,
    ),
    CompanyServiceCategory(
      id: 'repairs',
      name: 'Reparaciones',
      asset: AppAssets.workerRepairs,
    ),
    CompanyServiceCategory(
      id: 'maintenance',
      name: 'Mantenimiento',
      asset: AppAssets.workerMaintenance,
    ),
    CompanyServiceCategory(
      id: 'installations',
      name: 'Instalaciones',
      asset: AppAssets.workerInstallations,
    ),
    CompanyServiceCategory(
      id: 'roofing',
      name: 'Techos',
      asset: AppAssets.workerRoofing,
    ),
    CompanyServiceCategory(
      id: 'ventilation',
      name: 'Ventilación',
      asset: AppAssets.workerVentilation,
    ),
    CompanyServiceCategory(
      id: 'welding',
      name: 'Soldadura',
      asset: AppAssets.workerWelding,
    ),
    CompanyServiceCategory(
      id: 'appliances',
      name: 'Electrodomésticos',
      asset: AppAssets.workerAppliances,
    ),
    CompanyServiceCategory(
      id: 'lawn-mowing',
      name: 'Corte de césped',
      asset: AppAssets.workerLawnMowing,
    ),
    CompanyServiceCategory(
      id: 'pest-control',
      name: 'Control de plagas',
      asset: AppAssets.workerPestControl,
    ),
  ];
}

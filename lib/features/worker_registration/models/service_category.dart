import '../../../core/constants/app_assets.dart';

class WorkerServiceCategory {
  const WorkerServiceCategory({
    required this.id,
    required this.name,
    required this.asset,
  });

  final String id;
  final String name;
  final String asset;
}

abstract final class WorkerServiceCategories {
  static const all = <WorkerServiceCategory>[
    WorkerServiceCategory(
      id: 'masonry',
      name: 'Albañilería',
      asset: AppAssets.workerMasonry,
    ),
    WorkerServiceCategory(
      id: 'electricity',
      name: 'Electricidad',
      asset: AppAssets.workerElectricity,
    ),
    WorkerServiceCategory(
      id: 'painting',
      name: 'Pintura',
      asset: AppAssets.workerPainting,
    ),
    WorkerServiceCategory(
      id: 'plumbing',
      name: 'Plomería',
      asset: AppAssets.workerPlumbing,
    ),
    WorkerServiceCategory(
      id: 'air-conditioning',
      name: 'Aire acondicionado',
      asset: AppAssets.workerAirConditioning,
    ),
    WorkerServiceCategory(
      id: 'gardening',
      name: 'Jardinería',
      asset: AppAssets.workerGardening,
    ),
    WorkerServiceCategory(
      id: 'moving',
      name: 'Flete / Mudanza',
      asset: AppAssets.workerMoving,
    ),
    WorkerServiceCategory(
      id: 'security',
      name: 'Seguridad',
      asset: AppAssets.workerSecurity,
    ),
    WorkerServiceCategory(
      id: 'carpentry',
      name: 'Carpintería',
      asset: AppAssets.workerCarpentry,
    ),
    WorkerServiceCategory(
      id: 'cleaning',
      name: 'Limpieza',
      asset: AppAssets.workerCleaning,
    ),
    WorkerServiceCategory(
      id: 'repairs',
      name: 'Reparaciones',
      asset: AppAssets.workerRepairs,
    ),
    WorkerServiceCategory(
      id: 'maintenance',
      name: 'Mantenimiento',
      asset: AppAssets.workerMaintenance,
    ),
    WorkerServiceCategory(
      id: 'installations',
      name: 'Instalaciones',
      asset: AppAssets.workerInstallations,
    ),
    WorkerServiceCategory(
      id: 'roofing',
      name: 'Techos',
      asset: AppAssets.workerRoofing,
    ),
    WorkerServiceCategory(
      id: 'ventilation',
      name: 'Ventilación',
      asset: AppAssets.workerVentilation,
    ),
    WorkerServiceCategory(
      id: 'welding',
      name: 'Soldadura',
      asset: AppAssets.workerWelding,
    ),
    WorkerServiceCategory(
      id: 'appliances',
      name: 'Electrodomésticos',
      asset: AppAssets.workerAppliances,
    ),
    WorkerServiceCategory(
      id: 'lawn-mowing',
      name: 'Corte de césped',
      asset: AppAssets.workerLawnMowing,
    ),
    WorkerServiceCategory(
      id: 'pest-control',
      name: 'Control de plagas',
      asset: AppAssets.workerPestControl,
    ),
  ];
}

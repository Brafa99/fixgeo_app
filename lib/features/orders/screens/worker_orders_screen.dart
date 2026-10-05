import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/enums/provider_type.dart';
import '../../../core/enums/service_request_status.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/distance_calculator.dart';
import '../../../models/client_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/worker_model.dart';
import '../../../services/client_service.dart';
import '../../../services/request_service.dart';
import '../../../services/service_service.dart';
import '../../../services/worker_service.dart';
import '../../home/widgets/home_bottom_navigation.dart';
import '../widgets/order_filter_tabs.dart';
import '../widgets/worker_availability_control.dart';
import '../widgets/worker_order_card.dart';
import '../widgets/worker_orders_empty_state.dart';
import 'worker_request_detail_screen.dart';

class WorkerOrdersScreen extends StatefulWidget {
  const WorkerOrdersScreen({
    this.worker,
    this.workerId = 'worker_001',
    this.workerService,
    this.requestService,
    this.clientService,
    this.serviceService,
    super.key,
  });

  final WorkerModel? worker;
  final String workerId;
  final WorkerService? workerService;
  final RequestService? requestService;
  final ClientService? clientService;
  final ServiceService? serviceService;

  @override
  State<WorkerOrdersScreen> createState() => _WorkerOrdersScreenState();
}

class _WorkerOrdersScreenState extends State<WorkerOrdersScreen> {
  late final WorkerService _workerService;
  late final RequestService _requestService;
  late final ClientService _clientService;
  late final ServiceService _serviceService;

  WorkerModel? _worker;
  bool _isAvailable = true;
  bool _isLoading = true;
  bool _hasError = false;

  List<ServiceRequestModel> _allWorkerRequests = const [];
  Map<String, ServiceModel> _servicesById = const {};
  Map<String, ClientModel> _clientsById = const {};

  WorkerOrdersFilter _selectedFilter = WorkerOrdersFilter.all;

  @override
  void initState() {
    super.initState();
    _workerService = widget.workerService ?? AppDependencies.workerService;
    _requestService = widget.requestService ?? AppDependencies.requestService;
    _clientService = widget.clientService ?? AppDependencies.clientService;
    _serviceService = widget.serviceService ?? AppDependencies.serviceService;

    if (widget.worker != null) {
      _worker = widget.worker;
      _isAvailable = widget.worker!.isAvailable;
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // 1. Obtain worker via WorkerService
      var worker = _worker;
      if (worker == null) {
        worker = await _workerService.getWorkerById(widget.workerId);
        if (worker == null) {
          throw StateError('Worker ${widget.workerId} not found.');
        }
        _worker = worker;
        _isAvailable = worker.isAvailable;
      }

      // 2. Fetch services, clients, and worker requests concurrently
      final servicesFuture = _serviceService.getServices();
      final clientsFuture = _clientService.getClients();
      final requestsFuture = _requestService.getRequestsForWorker(
        worker: worker,
        isAvailableOverride: _isAvailable,
      );

      final services = await servicesFuture;
      final clients = await clientsFuture;
      final requests = await requestsFuture;

      if (!mounted) return;
      setState(() {
        _servicesById = {for (final s in services) s.id: s};
        _clientsById = {for (final c in clients) c.id: c};
        _allWorkerRequests = requests;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onAvailabilityChanged(bool value) {
    setState(() {
      _isAvailable = value;
      if (_worker != null) {
        _worker = _worker!.copyWith(isAvailable: value);
      }
    });

    // Re-fetch worker requests with the updated availability status
    if (_worker != null) {
      _requestService
          .getRequestsForWorker(
            worker: _worker!,
            isAvailableOverride: value,
          )
          .then((requests) {
            if (mounted) {
              setState(() => _allWorkerRequests = requests);
            }
          })
          .catchError((_) {});
    }
  }

  List<ServiceRequestModel> get _newRequests {
    final worker = _worker;
    if (worker == null || !_isAvailable) return const [];
    return _allWorkerRequests.where((r) {
      final isNew = r.status == ServiceRequestStatus.pending &&
          (r.selectedProviderId == null || r.selectedProviderId == worker.id);
      return isNew;
    }).toList();
  }

  List<ServiceRequestModel> get _acceptedRequests {
    final worker = _worker;
    if (worker == null) return const [];
    return _allWorkerRequests.where((r) {
      return r.selectedProviderId == worker.id &&
          r.selectedProviderType == ProviderType.worker &&
          r.status == ServiceRequestStatus.accepted;
    }).toList();
  }

  List<ServiceRequestModel> get _displayedRequests {
    return switch (_selectedFilter) {
      WorkerOrdersFilter.all => _allWorkerRequests,
      WorkerOrdersFilter.newOrders => _newRequests,
      WorkerOrdersFilter.accepted => _acceptedRequests,
    };
  }

  void _openOrderDetail(ServiceRequestModel request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkerRequestDetailScreen(
          requestId: request.id,
        ),
      ),
    );
  }

  void _openAccountMenu() {
    Navigator.pushNamed(
      context,
      RouteNames.accountMenu,
      arguments: _worker,
    );
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.providerHome,
        arguments: _worker,
      );
      return;
    }
    if (index == 1) {
      return;
    }
    if (index == 2) {
      _openAccountMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildContent(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: HomeBottomNavigation(
                    currentIndex: 1,
                    onDestinationSelected: _handleNavigation,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando pedidos...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: 14),
              const Text(
                'No pudimos cargar tus pedidos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Intenta nuevamente.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _loadData,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    final worker = _worker;
    final displayedRequests = _displayedRequests;
    final coverageRadiusKm = worker?.coverageRadiusKm ?? 5.0;
    final radiusText = coverageRadiusKm % 1 == 0
        ? '${coverageRadiusKm.toInt()}'
        : coverageRadiusKm.toStringAsFixed(1);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        // 1. HEADER
        _buildHeader(),
        const SizedBox(height: 16),

        // 2. DISPONIBILIDAD DEL TRABAJADOR
        WorkerAvailabilityControl(
          isAvailable: _isAvailable,
          onChanged: _onAvailabilityChanged,
        ),
        const SizedBox(height: 24),

        // 3. SECCIÓN PRINCIPAL: Pedidos cercanos + Radio de búsqueda
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedidos cercanos',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Servicios solicitados dentro de tu zona',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    PhosphorIconsFill.mapPin,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'A $radiusText km',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // 4. FILTROS: Todas | Nuevas | Aceptadas
        OrderFilterTabs(
          selectedFilter: _selectedFilter,
          onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
          allCount: _allWorkerRequests.length,
          newCount: _newRequests.length,
          acceptedCount: _acceptedRequests.length,
        ),
        const SizedBox(height: 18),

        // 5. LISTA DE PEDIDOS / ESTADO VACÍO
        if (displayedRequests.isEmpty)
          WorkerOrdersEmptyState(
            title: _selectedFilter == WorkerOrdersFilter.accepted
                ? 'No tienes pedidos aceptados'
                : 'No hay pedidos nuevos',
            subtitle: _selectedFilter == WorkerOrdersFilter.accepted
                ? 'Los pedidos que aceptes aparecerán en esta sección.'
                : 'Cuando aparezca un servicio cerca de ti lo verás aquí.',
          )
        else
          ...displayedRequests.map((request) {
            final service = _servicesById[request.serviceId];
            final client = _clientsById[request.clientId];
            final distanceKm = worker != null
                ? calculateDistanceKm(
                    worker.latitude,
                    worker.longitude,
                    request.latitude,
                    request.longitude,
                  )
                : 0.0;

            return WorkerOrderCard(
              key: ValueKey('worker-order-${request.id}'),
              request: request,
              service: service,
              client: client,
              distanceKm: distanceKm,
              onTap: () => _openOrderDetail(request),
            );
          }),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Pedidos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('No tienes notificaciones pendientes.'),
                    ),
                  );
              },
              tooltip: AppStrings.notifications,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                shadowColor: AppColors.shadow,
                elevation: 1,
              ),
              icon: const Icon(PhosphorIconsRegular.bell, size: 22),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: _openAccountMenu,
          tooltip: AppStrings.openMenu,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border),
            shadowColor: AppColors.shadow,
            elevation: 1,
          ),
          icon: const Icon(PhosphorIconsRegular.list, size: 22),
        ),
      ],
    );
  }
}

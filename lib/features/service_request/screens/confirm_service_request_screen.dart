import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../services/request_service.dart';
import '../../../services/service_service.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../controllers/confirm_service_request_controller.dart';
import '../models/searching_providers_arguments.dart';
import '../widgets/request_flow_progress.dart';
import '../widgets/request_primary_button.dart';

class ConfirmServiceRequestScreen extends StatefulWidget {
  const ConfirmServiceRequestScreen({
    required this.request,
    this.serviceName,
    this.user,
    this.serviceService,
    this.requestService,
    this.clock,
    super.key,
  });

  final ServiceRequestModel request;
  final String? serviceName;
  final UserModel? user;
  final ServiceService? serviceService;
  final RequestService? requestService;
  final DateTime Function()? clock;

  @override
  State<ConfirmServiceRequestScreen> createState() =>
      _ConfirmServiceRequestScreenState();
}

class _ConfirmServiceRequestScreenState
    extends State<ConfirmServiceRequestScreen> {
  late final ConfirmServiceRequestController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfirmServiceRequestController(
      request: widget.request,
      user: widget.user,
      serviceService: widget.serviceService ?? AppDependencies.serviceService,
      requestService: widget.requestService ?? AppDependencies.requestService,
      clock: widget.clock,
    );
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _editRequest() => Navigator.of(context).pop();

  Future<void> _searchProviders() async {
    final request = await _controller.startProviderSearch();
    if (!mounted) return;
    if (request == null) {
      final message = _controller.error;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
      return;
    }
    await Navigator.of(context).pushNamed(
      RouteNames.searchingProviders,
      arguments: SearchingProvidersArguments(
        request: request,
        service: _controller.service!,
        user: widget.user,
      ),
    );
  }

  String _dateLabel(ServiceRequestModel request) {
    final date = request.scheduledFor;
    if (date == null) return AppStrings.asSoonAsPossible;
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day.toString().padLeft(2, '0')} de '
        '${months[date.month - 1]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              onPressed: _editRequest,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: const Text(
              AppStrings.confirmRequest,
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
          ),
          body: SafeArea(child: _buildBody()),
          bottomNavigationBar: _buildBottomAction(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const LoadingIndicator(message: 'Cargando resumen...');
    }
    final service = _controller.service;
    if (service == null) {
      return _ConfirmationMessage(
        message: _controller.error ?? 'No encontramos el servicio solicitado.',
        onRetry: _controller.initialize,
      );
    }

    final request = _controller.request;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const RequestFlowProgress(currentStep: 3),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.home_repair_service_rounded,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Resumen de tu solicitud',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Verifica que los datos estén correctos antes de buscar '
              'prestadores.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 26),
            _SectionHeader(
              title: AppStrings.whatDoYouNeed,
              actionLabel: 'Editar',
              onAction: _editRequest,
            ),
            const SizedBox(height: 10),
            _SummaryBlock(
              icon: Icons.chat_bubble_outline_rounded,
              value: request.description,
            ),
            if (request.images.isNotEmpty) ...[
              const SizedBox(height: 26),
              const _SectionHeader(title: 'Fotos'),
              const SizedBox(height: 10),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: request.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(request.images[index]),
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: AppColors.primarySoft,
                        child: SizedBox.square(
                          dimension: 92,
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 26),
            _SectionHeader(
              title: AppStrings.location,
              actionLabel: 'Cambiar',
              onAction: _editRequest,
            ),
            const SizedBox(height: 10),
            _SummaryBlock(
              icon: Icons.location_on_outlined,
              value: request.address,
              secondary: 'Ubicación seleccionada',
            ),
            const SizedBox(height: 26),
            const _SectionHeader(title: '¿Cuándo?'),
            const SizedBox(height: 10),
            _SummaryBlock(
              icon: request.scheduledFor == null
                  ? Icons.schedule_rounded
                  : Icons.calendar_month_outlined,
              value: _dateLabel(request),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              key: const ValueKey('edit-service-request'),
              onPressed: _editRequest,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar'),
            ),
            if (_controller.error != null) ...[
              const SizedBox(height: 12),
              Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomAction() {
    if (_controller.isLoading || _controller.service == null) return null;
    return SafeArea(
      top: false,
      child: Container(
        key: const ValueKey('confirm-request-bottom-action'),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: RequestPrimaryButton(
              label: 'Buscar prestadores',
              isLoading: _controller.isSearching,
              onPressed:
                  _controller.isSearching ? null : _searchProviders,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock({
    required this.icon,
    required this.value,
    this.secondary,
  });

  final IconData icon;
  final String value;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (secondary != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    secondary!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationMessage extends StatelessWidget {
  const _ConfirmationMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

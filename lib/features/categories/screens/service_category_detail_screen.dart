import 'package:flutter/material.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../models/service_model.dart';
import '../../../models/user_model.dart';
import '../../../services/service_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../../service_request/models/create_service_request_arguments.dart';

class ServiceCategoryDetailScreen extends StatefulWidget {
  const ServiceCategoryDetailScreen({
    required this.serviceId,
    this.user,
    this.serviceService,
    super.key,
  });

  final String serviceId;
  final UserModel? user;
  final ServiceService? serviceService;

  @override
  State<ServiceCategoryDetailScreen> createState() =>
      _ServiceCategoryDetailScreenState();
}

class _ServiceCategoryDetailScreenState
    extends State<ServiceCategoryDetailScreen> {
  late final ServiceService _serviceService;
  ServiceModel? _service;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _serviceService = widget.serviceService ?? AppDependencies.serviceService;
    _loadService();
  }

  Future<void> _loadService() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final service = await _serviceService.getServiceById(widget.serviceId);
      if (!mounted) return;
      setState(() {
        _service = service;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _service = null;
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _goBack() async {
    final navigator = Navigator.of(context);
    if (await navigator.maybePop()) return;
    if (mounted) {
      await navigator.pushReplacementNamed(
        RouteNames.allCategories,
        arguments: widget.user,
      );
    }
  }

  void _requestService() {
    final service = _service;
    if (service == null) return;
    Navigator.of(context).pushNamed(
      RouteNames.createServiceRequest,
      arguments: CreateServiceRequestArguments(
        serviceId: service.id,
        user: widget.user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = _service;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          service?.name ?? AppStrings.serviceDetail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primarySoft, AppColors.cyanSoft],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: _buildBody(),
          ),
        ),
      ),
      bottomNavigationBar: service == null
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                  boxShadow: AppShadows.card,
                ),
                child: AppButton(
                  label: AppStrings.requestService,
                  onPressed: _requestService,
                ),
              ),
            ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator(message: AppStrings.loadingService);
    }
    if (_hasError) {
      return _ServiceDetailMessage(
        icon: Icons.cloud_off_rounded,
        message: AppStrings.serviceLoadError,
        onRetry: _loadService,
      );
    }
    final service = _service;
    if (service == null) {
      return const _ServiceDetailMessage(
        icon: Icons.search_off_rounded,
        message: AppStrings.serviceNotFound,
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      children: [
        _ServiceHeroImage(service: service),
        const SizedBox(height: AppSizes.spacingLg),
        Text(
          service.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              service.category,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingMd),
        Text(
          service.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (service.examples.isNotEmpty) ...[
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.requestableServices,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                for (final example in service.examples)
                  _ServiceExample(label: example),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ServiceHeroImage extends StatelessWidget {
  const _ServiceHeroImage({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cyanSoft,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (service.icon.startsWith('assets/')) {
      return OptimizedAssetImage(
        assetName: service.icon,
        cacheWidth: AppImageDecodeSize.illustration,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    if (service.icon.startsWith('http')) {
      return Image.network(
        service.icon,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return const Center(
      child: Icon(
        Icons.home_repair_service_rounded,
        color: AppColors.primary,
        size: 72,
      ),
    );
  }
}

class _ServiceExample extends StatelessWidget {
  const _ServiceExample({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceDetailMessage extends StatelessWidget {
  const _ServiceDetailMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppColors.textSecondary),
            const SizedBox(height: AppSizes.spacingMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.spacingLg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(AppStrings.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

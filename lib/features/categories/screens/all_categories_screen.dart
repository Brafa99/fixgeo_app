import 'package:flutter/material.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/service_model.dart';
import '../../../models/user_model.dart';
import '../../../services/company_service.dart';
import '../../../services/service_service.dart';
import '../../../services/worker_service.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../home/widgets/category_card.dart';
import '../models/provider_showcase_item.dart';
import '../models/service_category_detail_arguments.dart';
import '../widgets/provider_showcase_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({
    this.user,
    this.serviceService,
    this.workerService,
    this.companyService,
    super.key,
  });

  final UserModel? user;
  final ServiceService? serviceService;
  final WorkerService? workerService;
  final CompanyService? companyService;

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  late final ServiceService _serviceService;
  late final WorkerService _workerService;
  late final CompanyService _companyService;
  List<ServiceModel> _services = const [];
  List<ProviderShowcaseItem> _providers = const [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _serviceService = widget.serviceService ?? AppDependencies.serviceService;
    _workerService = widget.workerService ?? AppDependencies.workerService;
    _companyService = widget.companyService ?? AppDependencies.companyService;
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final servicesFuture = _serviceService.getServices();
      final workersFuture = _workerService.getWorkers();
      final companiesFuture = _companyService.getCompanies();
      final services = await servicesFuture;
      final workers = await workersFuture;
      final companies = await companiesFuture;
      final serviceNames = {
        for (final service in services) service.id: service.name,
      };
      final providers = <ProviderShowcaseItem>[
        ...workers.where((worker) => worker.isActive).map(
              (worker) => ProviderShowcaseItem.fromWorker(
                worker,
                serviceNames,
              ),
            ),
        ...companies.where((company) => company.isActive).map(
              (company) => ProviderShowcaseItem.fromCompany(
                company,
                serviceNames,
              ),
            ),
      ]..sort((first, second) => second.rating.compareTo(first.rating));
      if (!mounted) return;
      setState(() {
        _services = services;
        _providers = providers;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _services = const [];
        _providers = const [];
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
        RouteNames.home,
        arguments: widget.user,
      );
    }
  }

  void _openService(ServiceModel service) {
    Navigator.of(context).pushNamed(
      RouteNames.serviceCategoryDetail,
      arguments: ServiceCategoryDetailArguments(
        serviceId: service.id,
        user: widget.user,
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.comingSoon)),
      );
  }

  void _openProvider(ProviderShowcaseItem provider) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Perfil de ${provider.name}')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text(
          AppStrings.explore,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showNotifications,
            tooltip: AppStrings.notifications,
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator(message: AppStrings.loadingCategories);
    }
    if (_hasError) {
      return _CategoriesError(onRetry: _loadContent);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth < 360 ? 2 : 3;
        return CustomScrollView(
          key: const ValueKey('explore-content'),
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(18, 22, 18, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(
                  title: AppStrings.providersAndCompanies,
                ),
              ),
            ),
            if (_providers.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Text(
                    AppStrings.noProviders,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    scrollDirection: Axis.horizontal,
                    itemCount: _providers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final provider = _providers[index];
                      return ProviderShowcaseCard(
                        key: ValueKey('provider-${provider.id}'),
                        provider: provider,
                        onTap: () => _openProvider(provider),
                      );
                    },
                  ),
                ),
              ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(18, 28, 18, 14),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(title: AppStrings.services),
              ),
            ),
            if (_services.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                  child: Text(
                    AppStrings.noCategories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                sliver: SliverGrid(
                  key: const ValueKey('categories-grid'),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final service = _services[index];
                      return CategoryCard(
                        key: ValueKey('service-category-${service.id}'),
                        name: service.name,
                        image: service.icon,
                        isSelected: false,
                        onTap: () => _openService(service),
                      );
                    },
                    childCount: _services.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 21,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.35,
      ),
    );
  }
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            const Text(
              AppStrings.categoriesLoadError,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.spacingSm),
            const Text(
              AppStrings.tryAgain,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.spacingLg),
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

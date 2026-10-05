import 'package:flutter/material.dart';

import '../../../core/config/app_dependencies.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../services/company_service.dart';
import '../../../services/worker_service.dart';
import '../controllers/searching_providers_controller.dart';
import '../widgets/request_flow_progress.dart';

class SearchingProvidersScreen extends StatefulWidget {
  const SearchingProvidersScreen({
    required this.request,
    required this.service,
    this.user,
    this.workerService,
    this.companyService,
    super.key,
  });

  final ServiceRequestModel request;
  final ServiceModel service;
  final UserModel? user;
  final WorkerService? workerService;
  final CompanyService? companyService;

  @override
  State<SearchingProvidersScreen> createState() =>
      _SearchingProvidersScreenState();
}

class _SearchingProvidersScreenState extends State<SearchingProvidersScreen> {
  late final SearchingProvidersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SearchingProvidersController(
      request: widget.request,
      service: widget.service,
      user: widget.user,
      workerService: widget.workerService ?? AppDependencies.workerService,
      companyService: widget.companyService ?? AppDependencies.companyService,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSearch());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startSearch() async {
    final results = await _controller.search();
    if (!mounted || results == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    await Navigator.of(context).pushReplacementNamed(
      RouteNames.nearbyProviders,
      arguments: results,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: const BackButton(),
            title: const Text(
              'Buscando prestadores',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                  child: Column(
                    children: [
                      const RequestFlowProgress(currentStep: 3),
                      const Spacer(),
                      const _SearchingIllustration(),
                      const SizedBox(height: 30),
                      const Text(
                        'Buscando prestadores\ncercanos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 27,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Estamos buscando trabajadores y empresas\n'
                        'disponibles en tu zona...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _SearchStatusRow(
                        label: 'Buscando trabajadores...',
                        complete: _controller.workersReady,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(height: 14),
                      _SearchStatusRow(
                        label: 'Buscando empresas...',
                        complete: _controller.companiesReady,
                        color: AppColors.purple,
                      ),
                      const SizedBox(height: 14),
                      _SearchStatusRow(
                        label: 'Ordenando por distancia...',
                        complete: _controller.isComplete,
                        color: AppColors.pink,
                      ),
                      if (_controller.error != null) ...[
                        const SizedBox(height: 22),
                        Text(
                          _controller.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _startSearch,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reintentar'),
                        ),
                      ],
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchingIllustration extends StatelessWidget {
  const _SearchingIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 145,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            left: 15,
            top: 66,
            child: _PersonBubble(color: AppColors.cyan),
          ),
          const Positioned(
            right: 15,
            top: 57,
            child: _PersonBubble(color: AppColors.pink),
          ),
          const Positioned(
            left: 50,
            top: 16,
            child: _Dot(color: AppColors.primarySoft, size: 19),
          ),
          const Positioned(
            right: 51,
            top: 18,
            child: _Dot(color: AppColors.purpleSoft, size: 14),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1),
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: Transform.rotate(
              angle: -0.65,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.blue, width: 9),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 18,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: 0.65,
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.purple,
                    size: 44,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 49,
            bottom: 1,
            child: Transform.rotate(
              angle: -0.68,
              child: Container(
                width: 24,
                height: 61,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonBubble extends StatelessWidget {
  const _PersonBubble({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_rounded, color: color, size: 25),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SearchStatusRow extends StatelessWidget {
  const _SearchStatusRow({
    required this.label,
    required this.complete,
    required this.color,
  });

  final String label;
  final bool complete;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: complete
              ? Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey('$label-complete'),
                  color: color,
                  size: 22,
                )
              : SizedBox.square(
                  key: ValueKey('$label-loading'),
                  dimension: 20,
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2.5,
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

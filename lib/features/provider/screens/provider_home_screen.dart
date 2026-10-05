import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../models/user_model.dart';
import '../../home/widgets/home_bottom_navigation.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({this.user, super.key});

  final UserModel? user;

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _selectedNavigationIndex = 0;

  void _openOrders() {
    Navigator.pushNamed(
      context,
      RouteNames.orders,
      arguments: widget.user,
    );
  }

  void _openAccountMenu() {
    Navigator.pushNamed(
      context,
      RouteNames.accountMenu,
      arguments: widget.user,
    );
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      setState(() => _selectedNavigationIndex = 0);
      return;
    }
    if (index == 1) {
      _openOrders();
      return;
    }
    if (index == 2) {
      _openAccountMenu();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workerName = widget.user?.name ?? 'Carlos';

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
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                    children: [
                      // Header
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Hola, $workerName! 👋',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Panel de control de prestador',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      ),
                      const SizedBox(height: 24),

                      // Quick access to orders card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySoft,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    PhosphorIconsRegular.listChecks,
                                    color: AppColors.primary,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pedidos de servicio',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Revisa solicitudes disponibles cerca de ti',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            FilledButton.icon(
                              onPressed: _openOrders,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(PhosphorIconsRegular.arrowRight, size: 18),
                              label: const Text(
                                'Ver pedidos',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: HomeBottomNavigation(
                    currentIndex: _selectedNavigationIndex,
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
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/home_bottom_navigation.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/orders_header.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _searchQuery = '';

  void _openLogin() {
    Navigator.pushNamed(context, RouteNames.login);
  }

  void _openAccountMenu() {
    Navigator.pushNamed(context, RouteNames.accountMenu);
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, RouteNames.home);
      return;
    }
    if (index == 2) {
      _openAccountMenu();
    }
  }

  void _showHowItWorks() {
    // Callback preparado para enlazar el contenido explicativo en el futuro.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: SizedBox.expand(
              child: Stack(
                children: [
                  OrdersHeader(
                    onEnter: _openLogin,
                    onMenu: _openAccountMenu,
                    onSearchChanged: (value) {
                      setState(() => _searchQuery = value.trim());
                    },
                  ),
                  Positioned(
                    top: 174,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final minHeight = math.max(
                            0.0,
                            constraints.maxHeight - 148,
                          );
                          return SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 30, 24, 118),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: minHeight),
                              child: Center(
                                child: Semantics(
                                  liveRegion: true,
                                  label: _searchQuery.isEmpty
                                      ? 'Sin pedidos por ahora'
                                      : 'No hay pedidos para $_searchQuery',
                                  child: OrdersEmptyState(
                                    onHowItWorksTap: _showHowItWorks,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
      ),
    );
  }
}

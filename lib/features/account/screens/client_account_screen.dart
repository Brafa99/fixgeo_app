import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/user_model.dart';
import '../../home/widgets/home_bottom_navigation.dart';
import '../widgets/account_option_tile.dart';
import '../widgets/client_account_drawer.dart';
import '../widgets/client_account_header.dart';
import '../widgets/client_profile_card.dart';

class ClientAccountScreen extends StatefulWidget {
  const ClientAccountScreen({this.user, super.key});

  final UserModel? user;

  @override
  State<ClientAccountScreen> createState() => _ClientAccountScreenState();
}

class _ClientAccountScreenState extends State<ClientAccountScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _displayName => widget.user?.fullName ?? AppStrings.mockClientName;

  void _showComingSoon() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.comingSoon)),
      );
  }

  void _closeDrawerAndShowComingSoon() {
    Navigator.of(context).pop();
    _showComingSoon();
  }

  void _replaceRoute(String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  void _navigateFromDrawer(String routeName, {Object? arguments}) {
    Navigator.of(context).pop();
    _replaceRoute(routeName, arguments: arguments);
  }

  void _signOut() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.home,
      (route) => false,
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        _replaceRoute(RouteNames.home, arguments: widget.user);
        return;
      case 1:
        _replaceRoute(RouteNames.orders, arguments: widget.user);
        return;
      case 2:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: ClientAccountDrawer(
        userName: _displayName,
        onClose: () => Navigator.of(context).pop(),
        onRequestService: _closeDrawerAndShowComingSoon,
        onHome: () => _navigateFromDrawer(
          RouteNames.home,
          arguments: widget.user,
        ),
        onOrders: () => _navigateFromDrawer(
          RouteNames.orders,
          arguments: widget.user,
        ),
        onDiscover: _closeDrawerAndShowComingSoon,
        onSettings: _closeDrawerAndShowComingSoon,
        onBecomeProvider: () => _navigateFromDrawer(
          RouteNames.workerRegisterBasic,
        ),
        onSignOut: _signOut,
        onWhatsapp: _closeDrawerAndShowComingSoon,
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 390,
                        child: Stack(
                          children: [
                            ClientAccountHeader(
                              onNotifications: _showComingSoon,
                              onMenu: () =>
                                  _scaffoldKey.currentState?.openEndDrawer(),
                            ),
                            Positioned(
                              top: 102,
                              left: 0,
                              right: 0,
                              child: ClientProfileCard(
                                name: _displayName,
                                roleLabel: AppStrings.clientRole,
                                profileImage: widget.user?.profileImage,
                                onCameraTap: _showComingSoon,
                                onSettingsTap: _showComingSoon,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 2, 18, 126),
                      sliver: SliverList.list(
                        children: [
                          AccountOptionTile(
                            icon: PhosphorIconsRegular.listChecks,
                            label: AppStrings.myOrders,
                            onTap: () => _replaceRoute(
                              RouteNames.orders,
                              arguments: widget.user,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AccountOptionTile(
                            icon: PhosphorIconsRegular.compass,
                            label: AppStrings.discover,
                            onTap: _showComingSoon,
                          ),
                          const SizedBox(height: 10),
                          AccountOptionTile(
                            icon: PhosphorIconsRegular.question,
                            label: AppStrings.howItWorks,
                            onTap: _showComingSoon,
                          ),
                          const SizedBox(height: 10),
                          AccountOptionTile(
                            icon: PhosphorIconsRegular.coins,
                            label: AppStrings.earnMoney,
                            onTap: _showComingSoon,
                          ),
                          const SizedBox(height: 10),
                          AccountOptionTile(
                            icon: PhosphorIconsRegular.toolbox,
                            label: AppStrings.exploreServices,
                            onTap: _showComingSoon,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: HomeBottomNavigation(
                    currentIndex: 2,
                    onDestinationSelected: _handleBottomNavigation,
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

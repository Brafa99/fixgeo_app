import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class ClientAccountDrawer extends StatelessWidget {
  const ClientAccountDrawer({
    required this.userName,
    required this.onClose,
    required this.onRequestService,
    required this.onHome,
    required this.onOrders,
    required this.onDiscover,
    required this.onSettings,
    required this.onBecomeProvider,
    required this.onSignOut,
    required this.onWhatsapp,
    super.key,
  });

  final String userName;
  final VoidCallback onClose;
  final VoidCallback onRequestService;
  final VoidCallback onHome;
  final VoidCallback onOrders;
  final VoidCallback onDiscover;
  final VoidCallback onSettings;
  final VoidCallback onBecomeProvider;
  final VoidCallback onSignOut;
  final VoidCallback onWhatsapp;

  @override
  Widget build(BuildContext context) {
    final drawerWidth = (MediaQuery.sizeOf(context).width * 0.88)
        .clamp(280.0, 390.0)
        .toDouble();

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    tooltip: AppStrings.closeMenu,
                    icon: const Icon(PhosphorIconsRegular.x, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppGradients.header,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onRequestService,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PhosphorIconsRegular.plusCircle,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              AppStrings.requestService,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accountCard,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        _initials(userName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            AppStrings.clientRole,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _DrawerItem(
                      icon: PhosphorIconsRegular.house,
                      label: AppStrings.homeTab,
                      onTap: onHome,
                    ),
                    _DrawerItem(
                      icon: PhosphorIconsRegular.listChecks,
                      label: AppStrings.myOrders,
                      onTap: onOrders,
                    ),
                    _DrawerItem(
                      icon: PhosphorIconsRegular.compass,
                      label: AppStrings.discover,
                      onTap: onDiscover,
                    ),
                    _DrawerItem(
                      icon: PhosphorIconsRegular.gear,
                      label: AppStrings.settings,
                      onTap: onSettings,
                    ),
                    _DrawerItem(
                      icon: PhosphorIconsRegular.briefcase,
                      label: AppStrings.becomeProvider,
                      onTap: onBecomeProvider,
                    ),
                    const Divider(height: 18, color: AppColors.border),
                    _DrawerItem(
                      icon: PhosphorIconsRegular.signOut,
                      label: AppStrings.signOut,
                      color: AppColors.error,
                      onTap: onSignOut,
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onWhatsapp,
                icon: const Icon(PhosphorIconsRegular.whatsappLogo, size: 22),
                label: const Text(AppStrings.whatsapp),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.whatsapp,
                  side: const BorderSide(color: AppColors.whatsapp),
                  minimumSize: const Size.fromHeight(46),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                AppStrings.version,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts
        .take(2)
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .join();
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minTileHeight: 48,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../widgets/account_auth_card.dart';
import '../widgets/account_menu_item.dart';
import '../widgets/account_section.dart';

class AccountMenuScreen extends StatelessWidget {
  const AccountMenuScreen({super.key});

  void _close(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    navigator.pushReplacementNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                28,
              ),
              children: [
                _AccountMenuHeader(
                  onClose: () => _close(context),
                  onRequestService: () => Navigator.pushNamed(
                    context,
                    RouteNames.login,
                  ),
                ),
                const SizedBox(height: 18),
                AccountAuthCard(
                  onLogin: () => Navigator.pushNamed(
                    context,
                    RouteNames.login,
                  ),
                  onRegister: () => Navigator.pushNamed(
                    context,
                    RouteNames.accountType,
                  ),
                ),
                const SizedBox(height: 26),
                AccountSection(
                  children: [
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.house,
                      title: AppStrings.homeTab,
                      isActive: true,
                      onTap: () => _close(context),
                    ),
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.listChecks,
                      title: AppStrings.requestsTab,
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.orders,
                      ),
                    ),
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.toolbox,
                      title: AppStrings.services,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AccountSection(
                  children: [
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.info,
                      title: AppStrings.discover,
                      showArrow: true,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.bookOpen,
                      title: AppStrings.termsAndConditions,
                      showArrow: true,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.shieldCheck,
                      title: AppStrings.privacyPolicy,
                      showArrow: true,
                      onTap: () {},
                    ),
                    AccountMenuItem(
                      icon: PhosphorIconsRegular.globe,
                      title: AppStrings.ourWebsite,
                      showArrow: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 280.ms, curve: Curves.easeOut).slideX(
                  begin: 0.05,
                  end: 0,
                  duration: 320.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: AppStrings.whatsapp,
        backgroundColor: AppColors.whatsapp,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(PhosphorIconsRegular.whatsappLogo, size: 30),
      ),
      bottomNavigationBar: const _VersionFooter(),
    );
  }
}

class _AccountMenuHeader extends StatelessWidget {
  const _AccountMenuHeader({
    required this.onClose,
    required this.onRequestService,
  });

  final VoidCallback onClose;
  final VoidCallback onRequestService;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          tooltip: AppStrings.close,
          icon: const Icon(PhosphorIconsRegular.x, size: 28),
          color: AppColors.textPrimary,
        ),
        const Spacer(),
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: AppGradients.header,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onRequestService,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  AppStrings.requestService,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            AppStrings.version,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

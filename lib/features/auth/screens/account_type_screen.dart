import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../widgets/account_type_card.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF2F9FF), Colors.white, Color(0xFFFFF7FF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AppBackButton(fallbackRoute: RouteNames.home),
                  ),
                  const SizedBox(height: AppSizes.spacingSm),
                  const _AccountTypeHeader(),
                  const SizedBox(height: AppSizes.spacingXl),
                  AccountTypeCard(
                    image: AppAssets.client,
                    title: AppStrings.client,
                    description: AppStrings.clientDescription,
                    accentColor: AppColors.cyan,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.registerClientPersonal,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingMd),
                  AccountTypeCard(
                    image: AppAssets.provider,
                    title: AppStrings.provider,
                    description: AppStrings.providerDescription,
                    accentColor: AppColors.blue,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.workerRegisterBasic,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingMd),
                  AccountTypeCard(
                    image: AppAssets.company,
                    title: AppStrings.company,
                    description: AppStrings.companyDescription,
                    accentColor: AppColors.purple,
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.companyRegisterBusiness,
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

class _AccountTypeHeader extends StatelessWidget {
  const _AccountTypeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F083B8C),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const OptimizedAssetImage(
            assetName: AppAssets.logo,
            cacheWidth: AppImageDecodeSize.logo,
          ),
        ),
        const SizedBox(height: AppSizes.spacingLg),
        const Text(
          AppStrings.chooseAccountType,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 27,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSm),
        const Text(
          AppStrings.chooseAccountTypeDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

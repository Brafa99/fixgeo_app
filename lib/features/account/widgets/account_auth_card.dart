import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import 'account_menu_item.dart';

class AccountAuthCard extends StatelessWidget {
  const AccountAuthCard({
    required this.onLogin,
    required this.onRegister,
    super.key,
  });

  final VoidCallback onLogin;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.accountCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            AccountMenuItem(
              icon: PhosphorIconsRegular.signIn,
              title: AppStrings.login,
              onTap: onLogin,
              showArrow: true,
            ),
            AccountMenuItem(
              icon: PhosphorIconsRegular.userPlus,
              title: AppStrings.register,
              onTap: onRegister,
              showArrow: true,
            ),
          ],
        ),
      ),
    );
  }
}

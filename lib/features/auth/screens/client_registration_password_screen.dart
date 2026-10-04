import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../../shared/widgets/app_progress_indicator.dart';

class ClientRegistrationPasswordScreen extends StatelessWidget {
  const ClientRegistrationPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        children: [
          const AppProgressIndicator(currentStep: 2, totalSteps: 2),
          const SizedBox(height: AppSizes.spacingXl),
          Text(
            AppStrings.createPassword,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.spacingLg),
          const AppPasswordField(label: AppStrings.password),
          const SizedBox(height: AppSizes.spacingMd),
          const AppPasswordField(label: AppStrings.repeatPassword),
          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text(AppStrings.acceptTerms),
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text(AppStrings.acceptPrivacy),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSizes.spacingLg),
          AppButton(label: AppStrings.createAccount, onPressed: () {}),
        ],
      ),
    );
  }
}

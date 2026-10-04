import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_progress_indicator.dart';
import '../../../shared/widgets/app_text_field.dart';

class ClientRegistrationContactScreen extends StatelessWidget {
  const ClientRegistrationContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        children: [
          const AppProgressIndicator(currentStep: 1, totalSteps: 2),
          const SizedBox(height: AppSizes.spacingXl),
          Text(
            AppStrings.contactDetails,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.spacingLg),
          const AppTextField(
            label: AppStrings.phoneNumber,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSizes.spacingMd),
          const AppTextField(
            label: AppStrings.optionalEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSizes.spacingXl),
          AppButton(
            label: AppStrings.continueLabel,
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.clientRegistrationPassword,
            ),
          ),
        ],
      ),
    );
  }
}

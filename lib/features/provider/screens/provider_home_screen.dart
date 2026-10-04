import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class ProviderHomeScreen extends StatelessWidget {
  const ProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.providerHome)),
    );
  }
}

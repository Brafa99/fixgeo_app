import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.companyHome)),
    );
  }
}

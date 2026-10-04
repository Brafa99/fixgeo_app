import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.clientHome)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSizes.radiusMd),
            Text(message!),
          ],
        ],
      ),
    );
  }
}

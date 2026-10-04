import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../models/request_preview.dart';
import 'request_card.dart';
import 'section_header.dart';

class RecentRequestsSection extends StatelessWidget {
  const RecentRequestsSection({required this.requests, super.key});

  final List<RequestPreview> requests;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLg),
      child: Column(
        children: [
          SectionHeader(
            title: AppStrings.recentRequests,
            actionLabel: AppStrings.seeAll,
            onAction: () {},
          ),
          const SizedBox(height: AppSizes.spacingSm),
          for (var index = 0; index < requests.length; index++) ...[
            RequestCard(request: requests[index], onTap: () {}),
            if (index != requests.length - 1)
              const SizedBox(height: AppSizes.spacingSm),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';

class ClientProfileCard extends StatelessWidget {
  const ClientProfileCard({
    required this.name,
    required this.roleLabel,
    required this.onCameraTap,
    required this.onSettingsTap,
    this.profileImage,
    super.key,
  });

  final String name;
  final String roleLabel;
  final String? profileImage;
  final VoidCallback onCameraTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(18, 52, 18, 0),
          padding: const EdgeInsets.fromLTRB(20, 68, 20, 22),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCFE0FF)),
                ),
                child: Text(
                  roleLabel,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: onSettingsTap,
                icon: const Icon(PhosphorIconsRegular.gear, size: 19),
                label: const Text(AppStrings.settings),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(132, 46),
                  side: const BorderSide(color: AppColors.primary),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        _ProfileAvatar(
          name: name,
          profileImage: profileImage,
          onCameraTap: onCameraTap,
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.name,
    required this.onCameraTap,
    this.profileImage,
  });

  final String name;
  final String? profileImage;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 116,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: ClipOval(child: _buildAvatarImage()),
            ),
          ),
          Positioned(
            right: -2,
            bottom: 2,
            child: IconButton(
              onPressed: onCameraTap,
              tooltip: 'Cambiar foto de perfil',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 3),
                minimumSize: const Size.square(38),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(PhosphorIconsRegular.camera, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    final image = profileImage;
    if (image != null && image.startsWith('assets/')) {
      return Image.asset(image, fit: BoxFit.cover);
    }
    if (image != null &&
        image.startsWith('http') &&
        !image.contains('.example')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackAvatar(),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return ColoredBox(
      color: AppColors.cyanSoft,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const OptimizedAssetImage(
            assetName: AppAssets.client,
            cacheWidth: AppImageDecodeSize.avatar,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.white.withValues(alpha: 0.78),
              child: Text(
                _initials(name),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts
        .take(2)
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .join();
  }
}

import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';

class SuccessStoriesSection extends StatelessWidget {
  const SuccessStoriesSection({super.key});

  static const _stories = <({
    String asset,
    String title,
    String customer,
    String status,
    Color statusColor,
    Color statusBackground,
  })>[
    (
      asset: AppAssets.categoryElectricity,
      title: 'Instalación eléctrica',
      customer: 'Fernando · La Paz',
      status: 'Completado',
      statusColor: Color(0xFF168A54),
      statusBackground: Color(0xFFE8F8EF),
    ),
    (
      asset: AppAssets.categoryCleaning,
      title: 'Limpieza completa',
      customer: 'Diana · Cochabamba',
      status: 'En progreso',
      statusColor: Color(0xFF1479F8),
      statusBackground: Color(0xFFEAF2FF),
    ),
    (
      asset: AppAssets.categoryPainting,
      title: 'Pintura de interiores',
      customer: 'Carla · Santa Cruz',
      status: 'Completado',
      statusColor: Color(0xFF168A54),
      statusBackground: Color(0xFFE8F8EF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: _SectionHeading(
            emoji: '🧰',
            title: 'Casos de éxito recientes',
            subtitle: 'Personas que encontraron la ayuda que necesitaban.',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 204,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.horizontal,
            itemCount: _stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final story = _stories[index];
              return _SuccessStoryCard(
                asset: story.asset,
                title: story.title,
                customer: story.customer,
                status: story.status,
                statusColor: story.statusColor,
                statusBackground: story.statusBackground,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SuccessStoryCard extends StatelessWidget {
  const _SuccessStoryCard({
    required this.asset,
    required this.title,
    required this.customer,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
  });

  final String asset;
  final String title;
  final String customer;
  final String status;
  final Color statusColor;
  final Color statusBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDDE8F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D083B8C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 126,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: AppColors.cyanSoft,
                    child: OptimizedAssetImage(
                      assetName: asset,
                      cacheWidth: AppImageDecodeSize.category,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withAlpha(40)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          status == 'Completado'
                              ? Icons.check_circle_rounded
                              : Icons.schedule_rounded,
                          size: 11,
                          color: statusColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        customer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HowFixGeoWorksSection extends StatelessWidget {
  const HowFixGeoWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 246,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: OptimizedAssetImage(
                    assetName: AppAssets.servicesPhone,
                    cacheWidth: AppImageDecodeSize.illustration,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 152,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A172033),
                          blurRadius: 14,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Necesito alguien que pinte mi sala',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'La app para el mantenimiento de tu hogar y negocio',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.04,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Contanos qué necesitás y FixGeo avisa a profesionales cercanos. '
            'Los interesados ingresan a tu pedido y te envían una propuesta.',
            style: _bodyStyle,
          ),
          const SizedBox(height: 14),
          const Text(
            'Cuando una propuesta te gusta, coordinás los detalles con el '
            'profesional y listo.',
            style: _bodyStyle,
          ),
          const SizedBox(height: 14),
          const Text(
            'Si sos prestador de servicios, también podés encontrar nuevos '
            'clientes y hacer crecer tu trabajo.',
            style: _bodyStyle,
          ),
        ],
      ),
    );
  }

  static const _bodyStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    height: 1.34,
    fontWeight: FontWeight.w500,
  );
}

class SocialNetworksSection extends StatelessWidget {
  const SocialNetworksSection({super.key});

  static const _networks = <({String label, String asset})>[
    (
      label: 'WhatsApp',
      asset: AppAssets.socialWhatsapp,
    ),
    (
      label: 'Instagram',
      asset: AppAssets.socialInstagram,
    ),
    (
      label: 'YouTube',
      asset: AppAssets.socialYoutube,
    ),
    (label: 'Facebook', asset: AppAssets.socialFacebook),
    (label: 'TikTok', asset: AppAssets.socialTiktok),
    (label: 'Telegram', asset: AppAssets.socialTelegram),
    (label: 'LinkedIn', asset: AppAssets.socialLinkedin),
    (label: 'X', asset: AppAssets.socialX),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: _SectionHeading(
            emoji: '📲',
            title: 'Nuestras redes sociales',
            subtitle: 'Seguinos y apoyá el talento local.',
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 162,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.horizontal,
            itemCount: _networks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final network = _networks[index];
              return _SocialCard(
                label: network.label,
                asset: network.asset,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({
    required this.label,
    required this.asset,
  });

  final String label;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Abrir $label',
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFDDE8F2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            width: 132,
            height: 158,
            child: Transform.scale(
              scale: 1.17,
              child: OptimizedAssetImage(
                assetName: asset,
                cacheWidth: AppImageDecodeSize.social,
                width: 132,
                height: 158,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wideCardWidth = (constraints.maxWidth - 12) * 0.52;
          return SizedBox(
            height: 246,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: wideCardWidth,
                  child: _ProviderCallout(onTap: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _LinkCard(
                          icon: PhosphorIconsRegular.question,
                          label: '¿Cómo funciona?',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _LinkCard(
                          icon: PhosphorIconsRegular.lightbulb,
                          label: 'Descubrir',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProviderCallout extends StatelessWidget {
  const _ProviderCallout({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFEAF2FF),
                child: OptimizedAssetImage(
                  assetName: AppAssets.workers,
                  cacheWidth: AppImageDecodeSize.illustration,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text(
                'Prestadores de servicios',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: AppColors.textSecondary,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.textPrimary, size: 25),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                  letterSpacing: -0.45,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}

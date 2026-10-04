import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/registration_success_dialog.dart';
import '../controllers/company_registration_controller.dart';
import '../models/service_category.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/registration_layout.dart';
import '../widgets/registration_step_intro.dart';

class CompanyConfirmationScreen extends StatefulWidget {
  const CompanyConfirmationScreen({this.controller, super.key});

  final CompanyRegistrationController? controller;

  @override
  State<CompanyConfirmationScreen> createState() =>
      _CompanyConfirmationScreenState();
}

class _CompanyConfirmationScreenState extends State<CompanyConfirmationScreen> {
  late final CompanyRegistrationController _controller;
  late final bool _ownsController;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CompanyRegistrationController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (!_controller.data.acceptedTerms) {
      setState(() => _showTermsError = true);
      return;
    }
    try {
      await _controller.submit();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => RegistrationSuccessDialog(
          title: '¡Empresa registrada!',
          message:
              'El perfil empresarial fue creado correctamente. Iniciá sesión '
              'para administrar tus servicios y oportunidades.',
          accountLabel:
              'La cuenta de tu empresa quedó validada y lista para usar.',
          onContinue: () => Navigator.pop(dialogContext),
        ),
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos completar el registro. Intentá de nuevo.'),
        ),
      );
    }
  }

  void _showLegalInformation(String title) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Este contenido se conectará con el documento legal '
                'correspondiente antes de publicar la aplicación.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setAccepted(bool value) {
    _controller.setAcceptedTerms(value);
    if (value && _showTermsError) setState(() => _showTermsError = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CompanyRegistrationLayout(
        currentStep: 5,
        bottomButton: CompanyPrimaryButton(
          label: 'Finalizar',
          isLoading: _controller.isSubmitting,
          onPressed: _controller.isSubmitting ? null : _finish,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanyStepIntro(
              title: 'Revisá y confirmá tu empresa',
              description:
                  'Verificá los datos antes de crear la cuenta empresarial.',
            ),
            const SizedBox(height: 24),
            _CompanySummaryCard(
              name: _controller.data.companyName,
              city: _controller.data.city,
              representative: '${_controller.data.representativeName} '
                      '${_controller.data.representativeLastName}'
                  .trim(),
              phone: _controller.data.phone.isEmpty
                  ? ''
                  : '${_controller.data.countryCode} ${_controller.data.phone}',
              email: _controller.data.email,
              presentation: _controller.data.presentation,
              serviceIds: _controller.data.services,
            ),
            const SizedBox(height: 24),
            _TermsConsent(
              value: _controller.data.acceptedTerms,
              onChanged: _setAccepted,
              onTermsTap: () => _showLegalInformation('Términos y condiciones'),
              onPrivacyTap: () => _showLegalInformation(
                'Política de privacidad de datos',
              ),
            ),
            if (_showTermsError) ...[
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Debés aceptar los términos para continuar.',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            const _CompanyPrivacyNote(),
          ],
        ),
      ),
    );
  }
}

class _CompanySummaryCard extends StatelessWidget {
  const _CompanySummaryCard({
    required this.name,
    required this.city,
    required this.representative,
    required this.phone,
    required this.email,
    required this.presentation,
    required this.serviceIds,
  });

  final String name;
  final String city;
  final String representative;
  final String phone;
  final String email;
  final String presentation;
  final List<String> serviceIds;

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty ? 'Tu empresa' : name;
    final displayCity = city.isEmpty ? 'Ciudad por confirmar' : city;
    final displayRepresentative =
        representative.isEmpty ? 'Representante por confirmar' : representative;
    final serviceNames = CompanyServiceCategories.all
        .where((service) => serviceIds.contains(service.id))
        .map((service) => service.name)
        .toList(growable: false);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  gradient: AppGradients.header,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: const Icon(
                  PhosphorIconsRegular.buildings,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CUENTA EMPRESA',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${serviceNames.length} '
                      '${serviceNames.length == 1 ? 'servicio seleccionado' : 'servicios seleccionados'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          _CompanyDetailRow(
            icon: PhosphorIconsRegular.user,
            label: 'Representante',
            value: displayRepresentative,
          ),
          const SizedBox(height: 13),
          _CompanyDetailRow(
            icon: PhosphorIconsRegular.mapPin,
            label: 'Ubicación',
            value: displayCity,
          ),
          if (phone.trim().isNotEmpty) ...[
            const SizedBox(height: 13),
            _CompanyDetailRow(
              icon: PhosphorIconsRegular.phone,
              label: 'Teléfono',
              value: phone,
            ),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 13),
            _CompanyDetailRow(
              icon: PhosphorIconsRegular.envelopeSimple,
              label: 'Correo',
              value: email,
            ),
          ],
          if (presentation.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.purpleSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SOBRE LA EMPRESA',
                    style: TextStyle(
                      color: AppColors.purple,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    presentation,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (serviceNames.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text(
              'Servicios seleccionados',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: serviceNames
                  .map(
                    (service) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.blue.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        service,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompanyDetailRow extends StatelessWidget {
  const _CompanyDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsConsent extends StatelessWidget {
  const _TermsConsent({
    required this.value,
    required this.onChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: value,
            activeColor: AppColors.purple,
            side: const BorderSide(
              color: AppColors.border,
              width: 1.5,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (checked) => onChanged(checked ?? false),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Acepto los ', style: _termsStyle),
              _LegalLink(
                label: 'términos y condiciones',
                onTap: onTermsTap,
              ),
              const Text(' de uso y la ', style: _termsStyle),
              _LegalLink(
                label: 'política de privacidad de datos',
                onTap: onPrivacyTap,
              ),
              const Text('.', style: _termsStyle),
            ],
          ),
        ),
      ],
    );
  }

  static const _termsStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    height: 1.45,
  );
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.purple,
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.purple,
          ),
        ),
      ),
    );
  }
}

class _CompanyPrivacyNote extends StatelessWidget {
  const _CompanyPrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.purpleSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIconsRegular.shieldCheck,
            color: AppColors.purple,
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Los datos de tu empresa se usarán únicamente para validar y '
              'administrar la cuenta en FixGeo.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

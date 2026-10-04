import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/registration_success_dialog.dart';
import '../controllers/worker_registration_controller.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/worker_registration_layout.dart';
import '../widgets/worker_step_intro.dart';

class WorkerConfirmationScreen extends StatefulWidget {
  const WorkerConfirmationScreen({this.controller, super.key});

  final WorkerRegistrationController? controller;

  @override
  State<WorkerConfirmationScreen> createState() =>
      _WorkerConfirmationScreenState();
}

class _WorkerConfirmationScreenState extends State<WorkerConfirmationScreen> {
  late final WorkerRegistrationController _controller;
  late final bool _ownsController;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WorkerRegistrationController();
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
          title: '¡Tu perfil está listo!',
          message: 'Completaste el registro profesional. Iniciá sesión para '
              'mostrar tus servicios y recibir oportunidades.',
          accountLabel:
              'Tu perfil de trabajador quedó creado y listo para usar.',
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
      builder: (context, _) => WorkerRegistrationLayout(
        currentStep: 5,
        bottomButton: WorkerPrimaryButton(
          label: 'Finalizar registro',
          isLoading: _controller.isSubmitting,
          onPressed: _controller.isSubmitting ? null : _finish,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WorkerStepIntro(
              title: 'Revisá y confirmá',
              description:
                  'Estás a un paso de crear tu perfil como trabajador.',
            ),
            const SizedBox(height: 24),
            _WorkerSummaryCard(
              name: '${_controller.data.firstName} '
                      '${_controller.data.lastName}'
                  .trim(),
              city: _controller.data.city,
              serviceCount: _controller.data.categories.length,
            ),
            const SizedBox(height: 24),
            _TermsConsent(
              value: _controller.data.acceptedTerms,
              onChanged: _setAccepted,
              onTermsTap: () => _showLegalInformation('Términos y condiciones'),
              onPrivacyTap: () =>
                  _showLegalInformation('Política de privacidad'),
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
            const _PrivacyNote(),
          ],
        ),
      ),
    );
  }
}

class _WorkerSummaryCard extends StatelessWidget {
  const _WorkerSummaryCard({
    required this.name,
    required this.city,
    required this.serviceCount,
  });

  final String name;
  final String city;
  final int serviceCount;

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty ? 'Tu perfil profesional' : name;
    final displayCity = city.isEmpty ? 'Ciudad por confirmar' : city;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              gradient: AppGradients.brand,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: const Icon(
              PhosphorIconsRegular.identificationCard,
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
                  'PERFIL PROFESIONAL',
                  style: TextStyle(
                    color: AppColors.blue,
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
                const SizedBox(height: 7),
                Text(
                  '$displayCity  ·  $serviceCount '
                  '${serviceCount == 1 ? 'servicio' : 'servicios'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
            activeColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border, width: 1.5),
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
              _WorkerLegalLink(
                label: 'términos y condiciones',
                onTap: onTermsTap,
              ),
              const Text(' y la ', style: _termsStyle),
              _WorkerLegalLink(
                label: 'política de privacidad',
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

class _WorkerLegalLink extends StatelessWidget {
  const _WorkerLegalLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          height: 1.45,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primary,
        ),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIconsRegular.shieldCheck,
            color: AppColors.primary,
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tus datos se usarán únicamente para operar tu cuenta y mejorar '
              'la seguridad de FixGeo.',
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

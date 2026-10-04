import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/registration_success_dialog.dart';
import '../controllers/register_controller.dart';
import '../controllers/register_validators.dart';
import '../widgets/password_field.dart';
import '../widgets/register_page_layout.dart';
import '../widgets/register_primary_button.dart';
import '../widgets/register_step_intro.dart';

class RegisterStepThreeScreen extends StatefulWidget {
  const RegisterStepThreeScreen({this.controller, super.key});

  final RegisterController? controller;

  @override
  State<RegisterStepThreeScreen> createState() =>
      _RegisterStepThreeScreenState();
}

class _RegisterStepThreeScreenState extends State<RegisterStepThreeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final RegisterController _controller;
  late final bool _ownsController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? RegisterController();
    _passwordController = TextEditingController(
      text: _controller.data.password,
    );
    _confirmPasswordController = TextEditingController(
      text: _controller.data.confirmPassword,
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateAccessData(
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    try {
      await _controller.submit();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => RegistrationSuccessDialog(
          title: '¡Tu cuenta está lista!',
          message: 'Completaste el registro correctamente. Ya podés ingresar y '
              'encontrar profesionales cerca de vos.',
          accountLabel:
              'Tu perfil de cliente quedó creado y protegido en FixGeo.',
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => RegisterPageLayout(
        currentStep: 3,
        bottomButton: RegisterPrimaryButton(
          label: 'Finalizar',
          isLoading: _controller.isSubmitting,
          onPressed: _controller.canSubmit ? _finish : null,
        ),
        content: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegisterStepIntro(
                  title: 'Datos de acceso',
                  description: 'Creá una contraseña segura para tu cuenta.',
                ),
                const SizedBox(height: 28),
                PasswordField(
                  label: 'Contraseña',
                  hintText: 'Escribí una clave que recuerdes',
                  controller: _passwordController,
                  validator: RegisterValidators.password,
                  showHelp: true,
                  onChanged: (value) =>
                      _controller.updateAccessData(password: value),
                ),
                const SizedBox(height: 20),
                PasswordField(
                  label: 'Repetir contraseña',
                  hintText: 'Repetí la nueva clave',
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (value) => RegisterValidators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  onChanged: (value) => _controller.updateAccessData(
                    confirmPassword: value,
                  ),
                ),
                const SizedBox(height: 12),
                const _PasswordHint(),
                const SizedBox(height: 22),
                _TermsConsent(
                  value: _controller.data.acceptedTerms,
                  onChanged: (value) =>
                      _controller.updateAccessData(acceptedTerms: value),
                  onTermsTap: () =>
                      _showLegalInformation('Términos y condiciones'),
                  onPrivacyTap: () => _showLegalInformation(
                    'Política de privacidad de datos',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordHint extends StatelessWidget {
  const _PasswordHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.purpleSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIconsRegular.shieldCheck,
            color: AppColors.purple,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Usá al menos 8 caracteres, una letra y un número. También '
              'podés usar símbolos como @, # o !.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.35,
              ),
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
        Transform.translate(
          offset: const Offset(-9, -9),
          child: Checkbox(
            value: value,
            activeColor: AppColors.blue,
            onChanged: (checked) => onChanged(checked ?? false),
          ),
        ),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Acepto los ',
                style: _termsStyle,
              ),
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
            color: AppColors.primary,
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

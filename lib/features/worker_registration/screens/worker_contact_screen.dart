import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/worker_registration_controller.dart';
import '../controllers/worker_registration_validators.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/worker_registration_layout.dart';
import '../widgets/worker_step_intro.dart';

class WorkerContactScreen extends StatefulWidget {
  const WorkerContactScreen({this.controller, super.key});

  final WorkerRegistrationController? controller;

  @override
  State<WorkerContactScreen> createState() => _WorkerContactScreenState();
}

class _WorkerContactScreenState extends State<WorkerContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late final WorkerRegistrationController _controller;
  late final bool _ownsController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WorkerRegistrationController();
    _phoneController = TextEditingController(text: _controller.data.phone);
    _emailController = TextEditingController(text: _controller.data.email);
    _passwordController = TextEditingController(
      text: _controller.data.password,
    );
    _confirmPasswordController = TextEditingController(
      text: _controller.data.confirmPassword,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateContact(
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    Navigator.pushNamed(
      context,
      RouteNames.workerRegisterServices,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkerRegistrationLayout(
      currentStep: 3,
      bottomButton: WorkerPrimaryButton(
        label: 'Siguiente',
        onPressed: _continue,
      ),
      content: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkerStepIntro(
                title: 'Contacto y acceso',
                description:
                    'Estos datos permiten que tus clientes te contacten y que '
                    'vos ingreses a tu cuenta.',
              ),
              const SizedBox(height: 26),
              WorkerTextField(
                label: 'Número de teléfono',
                hintText: '70000000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                prefix: const _CountryCodePrefix(),
                validator: WorkerRegistrationValidators.phone,
                onChanged: (value) => _controller.updateContact(phone: value),
              ),
              const SizedBox(height: 18),
              WorkerTextField(
                label: 'Correo electrónico (opcional)',
                hintText: 'nombre@correo.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: WorkerRegistrationValidators.optionalEmail,
                onChanged: (value) => _controller.updateContact(email: value),
              ),
              const SizedBox(height: 18),
              WorkerPasswordField(
                hintText: 'Creá una contraseña segura',
                controller: _passwordController,
                showHelp: true,
                validator: WorkerRegistrationValidators.password,
                onChanged: (value) =>
                    _controller.updateContact(password: value),
              ),
              const SizedBox(height: 18),
              WorkerPasswordField(
                label: 'Repetir contraseña',
                hintText: 'Volvé a escribir tu contraseña',
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    WorkerRegistrationValidators.confirmPassword(
                  value,
                  _passwordController.text,
                ),
                onChanged: (value) =>
                    _controller.updateContact(confirmPassword: value),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
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
        ),
      ),
    );
  }
}

class _CountryCodePrefix extends StatelessWidget {
  const _CountryCodePrefix();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🇧🇴', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            const Text(
              '+591',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(width: 1, height: 26, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}

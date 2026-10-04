import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/register_controller.dart';
import '../controllers/register_validators.dart';
import '../widgets/register_page_layout.dart';
import '../widgets/register_primary_button.dart';
import '../widgets/register_step_intro.dart';
import '../widgets/register_text_field.dart';

class RegisterStepTwoScreen extends StatefulWidget {
  const RegisterStepTwoScreen({this.controller, super.key});

  final RegisterController? controller;

  @override
  State<RegisterStepTwoScreen> createState() => _RegisterStepTwoScreenState();
}

class _RegisterStepTwoScreenState extends State<RegisterStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final RegisterController _controller;
  late final bool _ownsController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? RegisterController();
    _phoneController = TextEditingController(text: _controller.data.phone);
    _emailController = TextEditingController(text: _controller.data.email);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateContactData(
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );
    Navigator.pushNamed(
      context,
      RouteNames.registerClientAccess,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterPageLayout(
      currentStep: 2,
      bottomButton: RegisterPrimaryButton(
        label: 'Siguiente',
        onPressed: _continue,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RegisterStepIntro(
              title: 'Vamos a crear tu cuenta',
              description: 'Con estos datos podrás ingresar a tu cuenta.',
            ),
            const SizedBox(height: 28),
            RegisterTextField(
              label: 'Número de teléfono',
              hintText: '67212345',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              validator: RegisterValidators.bolivianPhone,
              onChanged: (value) => _controller.updateContactData(phone: value),
              prefix: const _BoliviaPrefix(),
            ),
            const SizedBox(height: 20),
            RegisterTextField(
              label: 'Correo electrónico (opcional)',
              hintText: 'Ej: juan_gonzalez@gmail.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: RegisterValidators.optionalEmail,
              onChanged: (value) => _controller.updateContactData(email: value),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cyanSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Usaremos estos datos únicamente para identificar tu '
                      'cuenta y mantenerte al tanto de tus pedidos.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
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

class _BoliviaPrefix extends StatelessWidget {
  const _BoliviaPrefix();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 10, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇧🇴', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 7),
          const Text(
            '+591',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 26, color: AppColors.border),
        ],
      ),
    );
  }
}

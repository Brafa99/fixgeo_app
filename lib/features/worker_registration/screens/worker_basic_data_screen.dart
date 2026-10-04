import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../controllers/worker_registration_controller.dart';
import '../controllers/worker_registration_validators.dart';
import '../widgets/city_selector.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/worker_registration_layout.dart';
import '../widgets/worker_step_intro.dart';

class WorkerBasicDataScreen extends StatefulWidget {
  const WorkerBasicDataScreen({this.controller, super.key});

  final WorkerRegistrationController? controller;

  @override
  State<WorkerBasicDataScreen> createState() => _WorkerBasicDataScreenState();
}

class _WorkerBasicDataScreenState extends State<WorkerBasicDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final WorkerRegistrationController _controller;
  late final bool _ownsController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _documentController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WorkerRegistrationController();
    _firstNameController = TextEditingController(
      text: _controller.data.firstName,
    );
    _lastNameController = TextEditingController(
      text: _controller.data.lastName,
    );
    _documentController = TextEditingController(
      text: _controller.data.document,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _documentController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateBasicData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      document: _documentController.text.trim(),
    );
    Navigator.pushNamed(
      context,
      RouteNames.workerRegisterPresentation,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkerRegistrationLayout(
      currentStep: 1,
      bottomButton: WorkerPrimaryButton(
        label: 'Siguiente',
        onPressed: _continue,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WorkerStepIntro(
              title: 'Tus datos básicos',
              description:
                  'Contanos quién sos para crear tu perfil profesional.',
            ),
            const SizedBox(height: 26),
            WorkerTextField(
              label: 'Nombre',
              hintText: 'Ingresá tu nombre',
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.givenName],
              validator: (value) => WorkerRegistrationValidators.requiredText(
                value,
                'El nombre',
              ),
              onChanged: (value) =>
                  _controller.updateBasicData(firstName: value),
            ),
            const SizedBox(height: 18),
            WorkerTextField(
              label: 'Apellido',
              hintText: 'Ingresá tu apellido',
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: (value) => WorkerRegistrationValidators.requiredText(
                value,
                'El apellido',
              ),
              onChanged: (value) =>
                  _controller.updateBasicData(lastName: value),
            ),
            const SizedBox(height: 18),
            WorkerTextField(
              label: 'CI o RUC',
              hintText: 'Ej.: 12345678',
              controller: _documentController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
                LengthLimitingTextInputFormatter(20),
              ],
              validator: WorkerRegistrationValidators.document,
              onChanged: (value) =>
                  _controller.updateBasicData(document: value),
              labelTrailing: const WorkerHelpButton(
                message: 'Usamos tu CI o RUC para validar tu identidad. No se '
                    'mostrará públicamente en tu perfil.',
              ),
            ),
            const SizedBox(height: 18),
            WorkerCitySelector(
              selectedCity: _controller.data.city,
              validator: (value) => WorkerRegistrationValidators.requiredText(
                value,
                'La ciudad',
              ),
              onSelected: (city) {
                _controller.updateBasicData(city: city);
                _formKey.currentState?.validate();
              },
            ),
          ],
        ),
      ),
    );
  }
}

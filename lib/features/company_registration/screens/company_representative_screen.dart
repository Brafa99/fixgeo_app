import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../controllers/company_registration_controller.dart';
import '../controllers/company_registration_validators.dart';
import '../widgets/city_selector.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/registration_layout.dart';
import '../widgets/registration_step_intro.dart';

class CompanyRepresentativeScreen extends StatefulWidget {
  const CompanyRepresentativeScreen({this.controller, super.key});

  final CompanyRegistrationController? controller;

  @override
  State<CompanyRepresentativeScreen> createState() =>
      _CompanyRepresentativeScreenState();
}

class _CompanyRepresentativeScreenState
    extends State<CompanyRepresentativeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final CompanyRegistrationController _controller;
  late final bool _ownsController;
  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _documentController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CompanyRegistrationController();
    _nameController = TextEditingController(
      text: _controller.data.representativeName,
    );
    _lastNameController = TextEditingController(
      text: _controller.data.representativeLastName,
    );
    _documentController = TextEditingController(
      text: _controller.data.document,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _documentController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateRepresentative(
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      document: _documentController.text.trim(),
    );
    Navigator.pushNamed(
      context,
      RouteNames.companyRegisterContact,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompanyRegistrationLayout(
      currentStep: 2,
      bottomButton: CompanyPrimaryButton(
        label: 'Siguiente',
        onPressed: _continue,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CompanyStepIntro(
              title: 'Datos del representante',
              description:
                  'Necesitamos identificar a la persona responsable de la '
                  'cuenta empresarial.',
            ),
            const SizedBox(height: 26),
            CompanyTextField(
              label: 'Tu nombre',
              hintText: 'Ej: Juan',
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.givenName],
              validator: (value) => CompanyRegistrationValidators.requiredText(
                value,
                'El nombre',
              ),
              onChanged: (value) =>
                  _controller.updateRepresentative(name: value),
            ),
            const SizedBox(height: 18),
            CompanyTextField(
              label: 'Tu apellido',
              hintText: 'Ej: González',
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.familyName],
              validator: (value) => CompanyRegistrationValidators.requiredText(
                value,
                'El apellido',
              ),
              onChanged: (value) =>
                  _controller.updateRepresentative(lastName: value),
            ),
            const SizedBox(height: 18),
            CompanyTextField(
              label: 'N° C.I.N o RUC',
              hintText: 'Ingresá el documento',
              controller: _documentController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9-]')),
                LengthLimitingTextInputFormatter(20),
              ],
              validator: CompanyRegistrationValidators.document,
              onChanged: (value) =>
                  _controller.updateRepresentative(document: value),
              labelTrailing: const CompanyHelpButton(
                message: 'Ingresa tu Cédula de Identidad, NIT/RUC o documento '
                    'correspondiente de la empresa.',
              ),
            ),
            const SizedBox(height: 18),
            CompanyCitySelector(
              selectedCity: _controller.data.city,
              validator: (value) => CompanyRegistrationValidators.requiredText(
                value,
                'La ciudad',
              ),
              onSelected: (city) {
                _controller.updateRepresentative(city: city);
                _formKey.currentState?.validate();
              },
            ),
          ],
        ),
      ),
    );
  }
}

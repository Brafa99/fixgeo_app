import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../controllers/company_registration_controller.dart';
import '../controllers/company_registration_validators.dart';
import '../services/company_image_picker_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/image_picker_box.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/registration_layout.dart';
import '../widgets/registration_step_intro.dart';

class CompanyBusinessDataScreen extends StatefulWidget {
  const CompanyBusinessDataScreen({this.controller, super.key});

  final CompanyRegistrationController? controller;

  @override
  State<CompanyBusinessDataScreen> createState() =>
      _CompanyBusinessDataScreenState();
}

class _CompanyBusinessDataScreenState extends State<CompanyBusinessDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final CompanyRegistrationController _controller;
  late final bool _ownsController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _presentationController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CompanyRegistrationController();
    _companyNameController = TextEditingController(
      text: _controller.data.companyName,
    );
    _presentationController = TextEditingController(
      text: _controller.data.presentation,
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _presentationController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _pickLogo(CompanyImageSource source) async {
    try {
      await _controller.pickLogo(source);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos abrir tus imágenes. Intentá de nuevo.'),
        ),
      );
    }
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _controller.updateBusinessData(
      companyName: _companyNameController.text.trim(),
      presentation: _presentationController.text.trim(),
    );
    Navigator.pushNamed(
      context,
      RouteNames.companyRegisterRepresentative,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CompanyRegistrationLayout(
        currentStep: 1,
        bottomButton: CompanyPrimaryButton(
          label: 'Siguiente',
          onPressed: _controller.isPickingLogo ? null : _continue,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CompanyStepIntro(
                title: 'Datos de tu\nNegocio/Empresa',
                description:
                    'Completá la información con la que la comunidad conocerá '
                    'tu empresa.',
              ),
              const SizedBox(height: 26),
              CompanyTextField(
                label: 'Nombre de tu Negocio/Empresa',
                hintText: 'Ej: PuntoFix E.A.S.',
                controller: _companyNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    CompanyRegistrationValidators.requiredText(
                  value,
                  'El nombre de la empresa',
                ),
                onChanged: (value) =>
                    _controller.updateBusinessData(companyName: value),
              ),
              const SizedBox(height: 20),
              CompanyTextField(
                label: 'Presentación',
                hintText: 'Escribe aquí...',
                controller: _presentationController,
                maxLines: 5,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                onChanged: (value) =>
                    _controller.updateBusinessData(presentation: value),
                labelTrailing: const CompanyHelpButton(
                  message:
                      'Describe brevemente tu empresa, qué servicios brinda y '
                      'qué la diferencia.',
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Logo de tu empresa (opcional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CompanyHelpButton(
                    message:
                        'Podés seleccionar el logo de la empresa o tomar una '
                        'fotografía. También podrás cambiarlo más adelante.',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CompanyImagePickerBox(
                imagePath: _controller.data.logoPath,
                isLoading: _controller.isPickingLogo,
                onGalleryTap: () => _pickLogo(CompanyImageSource.gallery),
                onCameraTap: () => _pickLogo(CompanyImageSource.camera),
                onRemoveTap: _controller.removeLogo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

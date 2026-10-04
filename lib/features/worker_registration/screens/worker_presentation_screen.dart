import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../controllers/worker_registration_controller.dart';
import '../services/worker_image_picker_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/help_icon_button.dart';
import '../widgets/image_picker_box.dart';
import '../widgets/primary_bottom_button.dart';
import '../widgets/worker_registration_layout.dart';
import '../widgets/worker_step_intro.dart';

class WorkerPresentationScreen extends StatefulWidget {
  const WorkerPresentationScreen({this.controller, super.key});

  final WorkerRegistrationController? controller;

  @override
  State<WorkerPresentationScreen> createState() =>
      _WorkerPresentationScreenState();
}

class _WorkerPresentationScreenState extends State<WorkerPresentationScreen> {
  late final WorkerRegistrationController _controller;
  late final bool _ownsController;
  late final TextEditingController _presentationController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? WorkerRegistrationController();
    _presentationController = TextEditingController(
      text: _controller.data.presentation,
    );
  }

  @override
  void dispose() {
    _presentationController.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(WorkerImageSource source) async {
    try {
      await _controller.pickImage(source);
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
    _controller.updatePresentation(_presentationController.text.trim());
    Navigator.pushNamed(
      context,
      RouteNames.workerRegisterContact,
      arguments: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => WorkerRegistrationLayout(
        currentStep: 2,
        bottomButton: WorkerPrimaryButton(
          label: 'Siguiente',
          onPressed: _controller.isPickingImage ? null : _continue,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WorkerStepIntro(
              title: 'Presentá tu trabajo',
              description:
                  'Una buena imagen y una breve presentación generan más '
                  'confianza.',
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Foto de perfil o logo (opcional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                WorkerHelpButton(
                  message: 'Elegí una foto clara de tu rostro o el logo de tu '
                      'emprendimiento. Podrás cambiarla más adelante.',
                ),
              ],
            ),
            const SizedBox(height: 8),
            WorkerImagePickerBox(
              imagePath: _controller.data.imagePath,
              isLoading: _controller.isPickingImage,
              onGalleryTap: () => _pickImage(WorkerImageSource.gallery),
              onCameraTap: () => _pickImage(WorkerImageSource.camera),
              onRemoveTap: _controller.removeImage,
            ),
            const SizedBox(height: 24),
            WorkerTextField(
              label: 'Contanos sobre vos',
              hintText: 'Ej.: Tengo 8 años de experiencia en instalaciones y '
                  'mantenimiento...',
              controller: _presentationController,
              maxLines: 5,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              onChanged: _controller.updatePresentation,
              labelTrailing: const WorkerHelpButton(
                message:
                    'Podés mencionar tu experiencia, forma de trabajo, zonas '
                    'que cubrís o aquello que te diferencia.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

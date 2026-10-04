import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';
import 'custom_text_field.dart';

class WorkerPasswordField extends StatefulWidget {
  const WorkerPasswordField({
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.onChanged,
    this.label = 'Contraseña',
    this.showHelp = false,
    this.textInputAction = TextInputAction.next,
    super.key,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final bool showHelp;
  final TextInputAction textInputAction;

  @override
  State<WorkerPasswordField> createState() => _WorkerPasswordFieldState();
}

class _WorkerPasswordFieldState extends State<WorkerPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return WorkerTextField(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: true,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      labelTrailing: widget.showHelp
          ? const Tooltip(
              message:
                  'Mínimo 8 caracteres, una letra y un número. Podés usar símbolos.',
              child: Icon(
                PhosphorIconsRegular.question,
                color: AppColors.textSecondary,
                size: 17,
              ),
            )
          : null,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        tooltip: _obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
        color: AppColors.textSecondary,
        icon: Icon(
          _obscure ? PhosphorIconsRegular.eye : PhosphorIconsRegular.eyeSlash,
          size: 22,
        ),
      ),
    );
  }
}

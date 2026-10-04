import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';
import 'register_text_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.onChanged,
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
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return RegisterTextField(
      label: widget.label,
      labelTrailing: widget.showHelp
          ? const Tooltip(
              message: 'Mínimo 8 caracteres, una letra y un número',
              child: Icon(
                PhosphorIconsRegular.question,
                color: AppColors.textSecondary,
                size: 17,
              ),
            )
          : null,
      hintText: widget.hintText,
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autocorrect: false,
      enableSuggestions: false,
      enableInteractiveSelection: true,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
        color: AppColors.textSecondary,
        icon: Icon(
          _obscureText
              ? PhosphorIconsRegular.eye
              : PhosphorIconsRegular.eyeSlash,
          size: 22,
        ),
      ),
    );
  }
}

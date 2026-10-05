import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.label,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      prefixIcon: widget.prefixIcon,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        tooltip: _obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    );
  }
}

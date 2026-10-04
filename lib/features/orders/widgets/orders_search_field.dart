import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class OrdersSearchField extends StatelessWidget {
  const OrdersSearchField({
    required this.onChanged,
    this.onTap,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Explorar pedidos de otros clientes',
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(24),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(70)),
        ),
        child: TextField(
          onTap: onTap,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          cursorColor: Colors.white,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(
            hintText: 'Explorar pedidos de otros clientes',
            hintStyle: TextStyle(
              color: Color(0xFFDCEBFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.white,
              size: 22,
            ),
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 17),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: 80.ms,
          duration: 300.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.12,
          end: 0,
          delay: 80.ms,
          duration: 320.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

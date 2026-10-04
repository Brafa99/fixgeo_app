import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({this.fallbackRoute, super.key});

  final String? fallbackRoute;

  Future<void> _goBack(BuildContext context) async {
    final navigator = Navigator.of(context);
    final didPop = await navigator.maybePop();

    if (!didPop && context.mounted && fallbackRoute != null) {
      await navigator.pushReplacementNamed(fallbackRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => _goBack(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}

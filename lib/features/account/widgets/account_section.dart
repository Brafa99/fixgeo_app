import 'package:flutter/widgets.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({
    required this.children,
    this.spacing = 2,
    super.key,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

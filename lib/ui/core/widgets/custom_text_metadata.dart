import 'package:flutter/material.dart';

class CustomTextMetadata extends StatelessWidget {
  const CustomTextMetadata({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(leftText, style: theme.textTheme.labelMedium)),
        Text(rightText, style: theme.textTheme.labelMedium),
      ],
    );
  }
}

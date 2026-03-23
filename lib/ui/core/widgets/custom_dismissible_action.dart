import 'package:flutter/material.dart';

import '../themes/dimensions.dart';
import 'custom_icon.dart';

class CustomDismissibleAction extends StatelessWidget {
  const CustomDismissibleAction.left({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  }) : alignment = Alignment.centerLeft;
  const CustomDismissibleAction.right({
    super.key,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
  }) : alignment = Alignment.centerRight;

  final Alignment alignment;
  final String icon;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
        vertical: AppDimensions.paddingSmall,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: alignment,
      child: CustomIcon(
        iconPath: icon,
        color: iconColor ?? theme.colorScheme.onPrimary,
      ),
    );
  }
}

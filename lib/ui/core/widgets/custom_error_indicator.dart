import 'package:flutter/material.dart';

import '../themes/dimensions.dart';
import 'custom_icon.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              iconPath: CustomIcons.error,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: AppDimensions.paddingLarge),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            FilledButton.tonal(
              onPressed: onPressed,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  theme.colorScheme.error,
                ),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

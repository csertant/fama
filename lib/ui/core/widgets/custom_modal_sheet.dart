import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomModalSheet extends StatelessWidget {
  const CustomModalSheet({
    super.key,
    required this.title,
    this.description,
    required this.actionLabel,
    required this.onAction,
    required this.children,
    this.isLoading = false,
  });

  final String title;
  final String? description;
  final String actionLabel;
  final VoidCallback onAction;
  final List<Widget> children;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.paddingMedium,
        right: AppDimensions.paddingMedium,
        top: AppDimensions.paddingMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppDimensions.paddingSmall,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          if (description != null) ...[
            Text(description!, style: theme.textTheme.bodyMedium),
          ],
          ...children,
          FilledButton.tonal(
            onPressed: isLoading ? null : onAction,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(actionLabel, style: theme.textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}

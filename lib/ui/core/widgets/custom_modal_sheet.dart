import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

Future<T?> showCustomModalSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.borderRadiusMedium),
      ),
    ),
    builder: builder,
  );
}

class CustomModalSheet extends StatelessWidget {
  const CustomModalSheet({
    super.key,
    required this.listenable,
    required this.title,
    this.description,
    required this.actionLabel,
    required this.onAction,
    required this.childrenBuilder,
    this.isLoading = false,
  });

  final Listenable listenable;
  final String title;
  final String? description;
  final String actionLabel;
  final VoidCallback onAction;
  final List<Widget> Function(BuildContext context) childrenBuilder;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: listenable,
      builder: (context, child) {
        final children = childrenBuilder(context);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppDimensions.paddingMedium,
            right: AppDimensions.paddingMedium,
            top: AppDimensions.paddingMedium,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
    required this.child,
    this.show = true,
    this.label,
  });

  final Widget child;
  final bool show;
  final String? label;

  static const _badgeScale = 0.75;

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return child;
    }
    final theme = Theme.of(context);
    final hasLabel = label != null && label!.isNotEmpty;
    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: hasLabel
              ? AppDimensions.badgeSizeLarge
              : AppDimensions.badgeSizeSmall,
          minHeight: hasLabel
              ? AppDimensions.badgeSizeLarge
              : AppDimensions.badgeSizeSmall,
        ),
        child: hasLabel
            ? Center(
                child: Text(
                  label!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    height: 1,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
            : null,
      ),
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Transform.translate(
              offset: AppDimensions.badgeOffset,
              child: Transform.scale(
                scale: _badgeScale,
                alignment: Alignment.topRight,
                child: badge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/themes/dimensions.dart';
import '../../core/widgets/widgets.dart';

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    super.key,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final String title;
  final String subtitle;
  final CustomIconButton action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
              action,
            ],
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

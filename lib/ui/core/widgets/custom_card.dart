import 'package:flutter/material.dart';

import '../themes/dimensions.dart';
import 'custom_icon_button.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.headline,
    required this.actions,
    required this.title,
    required this.description,
    this.metadata = const [],
    this.padding = const EdgeInsets.all(AppDimensions.paddingMedium),
  });

  final String headline;
  final List<CustomIconButton> actions;
  final String title;
  final String description;
  final List<String> metadata;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppDimensions.paddingSmall,
        children: [
          Row(
            spacing: AppDimensions.paddingSmall,
            children: [
              Expanded(
                child: Text(headline, style: theme.textTheme.bodyMedium),
              ),
              ...actions,
            ],
          ),
          Text(title, style: theme.textTheme.titleMedium),
          Text(
            description,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: AppDimensions.paddingSmall,
            children: metadata
                .map((data) => Text(data, style: theme.textTheme.labelMedium))
                .toList(),
          ),
        ],
      ),
    );
  }
}

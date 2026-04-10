import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../themes/dimensions.dart';
import 'custom_icon_button.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.headline,
    required this.actions,
    required this.title,
    this.titleUrl,
    required this.description,
    this.metadata = const [],
    this.padding = const EdgeInsets.all(AppDimensions.paddingMedium),
  });

  final String headline;
  final List<CustomIconButton> actions;
  final String title;
  final String? titleUrl;
  final String description;
  final List<String> metadata;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsedTitleUrl = titleUrl == null || titleUrl!.isEmpty
        ? null
        : Uri.tryParse(titleUrl!);
    final metadataWidgets = [
      for (var index = 0; index < metadata.length; index++)
        if (index == 0)
          Expanded(
            child: Text(
              metadata[index],
              style: theme.textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        else
          Text(metadata[index], style: theme.textTheme.labelMedium),
    ];
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
          if (parsedTitleUrl == null)
            Text(title, style: theme.textTheme.titleMedium)
          else
            Link(
              uri: parsedTitleUrl,
              target: LinkTarget.blank,
              builder: (context, followLink) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: followLink,
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              },
            ),
          Text(
            description,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (metadataWidgets.isNotEmpty)
            Row(spacing: AppDimensions.paddingSmall, children: metadataWidgets),
        ],
      ),
    );
  }
}

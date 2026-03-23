import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomTextTitleWithSummary extends StatelessWidget {
  const CustomTextTitleWithSummary({
    super.key,
    required this.title,
    required this.summary,
  });

  final String title;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(
          summary,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

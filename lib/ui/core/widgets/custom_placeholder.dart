import 'package:flutter/material.dart';

import '../themes/dimensions.dart';
import 'widgets.dart';

class CustomPlaceholder extends StatelessWidget {
  const CustomPlaceholder({super.key, required this.message, this.action});

  final String message;
  final CustomIconButton? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: AppDimensions.paddingSmall,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}

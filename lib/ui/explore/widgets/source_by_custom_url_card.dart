import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../core/widgets/widgets.dart';

class SourceByCustomUrlCard extends StatelessWidget {
  const SourceByCustomUrlCard({
    super.key,
    required this.title,
    required this.onSubscribe,
  });

  final String title;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        CustomIconButton.normal(
          icon: CustomIcons.add,
          tooltip: localizations.exploreAddCustomSourceActionLabel,
          onTap: onSubscribe,
        ),
      ],
    );
  }
}

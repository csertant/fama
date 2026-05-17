import 'package:flutter/material.dart';

import '../../../domain/url_resolver/url_resolver.dart.dart';
import '../../../domain/url_resolver/url_strategies.dart';
import '../../core/themes/dimensions.dart';
import '../../core/widgets/widgets.dart';

class SourcePlatformChooser extends StatefulWidget {
  const SourcePlatformChooser({super.key, required this.onTap});

  final void Function(Platform) onTap;

  @override
  State<SourcePlatformChooser> createState() => _SourcePlatformChooserState();
}

class _SourcePlatformChooserState extends State<SourcePlatformChooser> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.paddingSmall,
      runSpacing: AppDimensions.paddingSmall,
      children: UrlResolver.supportedStrategies.map((strategy) {
        return CustomIconButton.normal(
          onTap: () => widget.onTap(strategy.platform),
          icon: strategy.iconPath,
          tooltip: strategy.platformName,
        );
      }).toList(),
    );
  }
}

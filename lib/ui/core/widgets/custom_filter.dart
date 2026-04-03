import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomFilter<T> extends StatelessWidget {
  const CustomFilter({
    super.key,
    required this.label,
    required this.selected,
    required this.options,
    required this.onOptionSelected,
  }) : assert(
         selected.length <= options.length,
         'Selected options cannot be more than available options',
       );

  final String label;
  final List<T> selected;
  final List<T> options;
  final void Function(T option) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimensions.paddingSmall,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: AppDimensions.paddingSmall,
          children: options.map((option) {
            final optionLabel = option.toString();
            return FilterChip(
              label: Text(optionLabel, style: theme.textTheme.labelMedium),
              selected: selected.contains(option),
              onSelected: (_) => onOptionSelected(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}

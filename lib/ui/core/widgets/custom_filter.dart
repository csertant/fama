import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class FilterLimit {
  static const int five = 5;
  static const int ten = 10;
  static const int twentyfive = 25;
  static const int fifty = 50;
  static const int hundred = 100;
  static const int defaultLimit = twentyfive;

  static List<int> get all => [five, ten, twentyfive, fifty, hundred];
}

class FilterDuration {
  static const Duration hour = Duration(hours: 1);
  static const Duration sixHours = Duration(hours: 6);
  static const Duration day = Duration(days: 1);
  static const Duration threeDays = Duration(days: 3);
  static const Duration week = Duration(days: 7);
  static const Duration month = Duration(days: 30);
  static const Duration year = Duration(days: 365);
  static const Duration defaultDuration = week;

  static List<Duration> get all => [
    hour,
    sixHours,
    day,
    threeDays,
    week,
    month,
    year,
  ];
}

class CustomFilter<T> extends StatelessWidget {
  const CustomFilter({
    super.key,
    required this.label,
    required this.selected,
    required this.options,
    required this.onOptionSelected,
    this.optionLabelBuilder,
  }) : assert(
         selected.length <= options.length,
         'Selected options cannot be more than available options',
       );

  final String label;
  final List<T> selected;
  final List<T> options;
  final void Function(T option) onOptionSelected;
  final String Function(T option)? optionLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppDimensions.paddingSmall,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Wrap(
          spacing: AppDimensions.paddingSmall,
          runSpacing: AppDimensions.paddingSmall,
          children: options.map((option) {
            final optionLabel =
                optionLabelBuilder?.call(option) ?? option.toString();
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

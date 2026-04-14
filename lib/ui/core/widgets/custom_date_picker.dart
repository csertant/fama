import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final void Function(DateTime?) onChanged;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime value;

  @override
  void initState() {
    super.initState();
    value = widget.value ?? AppDateTimeUtils.oneMonthAgo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.label, style: theme.textTheme.bodyMedium),
        GestureDetector(
          onTap: () =>
              showDatePicker(
                context: context,
                initialDate: value,
                firstDate: AppDateTimeUtils.firstPossibleDate(),
                lastDate: AppDateTimeUtils.lastPossibleDate(),
              ).then((date) {
                widget.onChanged(date);
                setState(() {
                  value = date ?? value;
                });
              }),
          child: Text(
            AppDateFormat.dateOnly.format(value),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

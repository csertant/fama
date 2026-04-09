import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.label,
    this.value = false,
    this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }
}

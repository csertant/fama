import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.errorText,
    this.hintText,
  });

  final TextEditingController? controller;
  final String? errorText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
        errorText: errorText,
        errorStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }
}

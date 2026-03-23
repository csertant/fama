import 'package:flutter/material.dart';

import 'widgets.dart';

class CustomTextWithActions extends StatelessWidget {
  const CustomTextWithActions({
    super.key,
    required this.text,
    required this.actions,
  });

  final String text;
  final List<CustomIconButton> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleSmall),
        ),
        ...actions,
      ],
    );
  }
}

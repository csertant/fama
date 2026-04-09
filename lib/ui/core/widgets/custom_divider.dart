import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      indent: AppDimensions.paddingMedium,
      endIndent: AppDimensions.paddingMedium,
    );
  }
}

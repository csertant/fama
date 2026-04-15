import 'package:flutter/material.dart';

import '../themes/colors.dart';
import '../themes/dimensions.dart';
import 'widgets.dart';

class CustomErrorBanner extends StatelessWidget {
  const CustomErrorBanner({
    super.key,
    required this.message,
    this.iconPath = CustomIcons.error,
  });

  final String message;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.lightGrey,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppDimensions.borderRadiusMedium,
        children: [
          CustomIcon(iconPath: iconPath),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

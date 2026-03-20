import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/url.dart';
import '../themes/dimensions.dart';
import 'custom_icon.dart';

enum CustomIconButtonType { normal, redirectInApp, redirectExternal }

class CustomIconButton extends StatelessWidget {
  const CustomIconButton.normal({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = AppDimensions.iconSizeMedium,
  }) : type = CustomIconButtonType.normal;

  CustomIconButton.redirectInApp({
    super.key,
    required this.icon,
    required final String route,
    required BuildContext context,
    this.size = AppDimensions.iconSizeMedium,
  }) : type = CustomIconButtonType.redirectInApp,
       onTap = (() => context.go(route));

  CustomIconButton.redirectExternal({
    super.key,
    required this.icon,
    required final String url,
    this.size = AppDimensions.iconSizeMedium,
  }) : type = CustomIconButtonType.redirectExternal,
       onTap = (() => safeLaunchUrl(Uri.parse(url)));

  final String icon;
  final VoidCallback onTap;
  final double size;
  final CustomIconButtonType type;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: CustomIcon(iconPath: icon, size: size),
    );
  }
}

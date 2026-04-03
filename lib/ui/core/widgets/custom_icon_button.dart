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
    this.tooltip,
    this.enabled = true,
    this.size = AppDimensions.iconSizeMedium,
    this.showBadge = false,
    this.badgeLabel,
  }) : type = CustomIconButtonType.normal;

  CustomIconButton.redirectInApp({
    super.key,
    required this.icon,
    required final String route,
    required BuildContext context,
    this.tooltip,
    this.enabled = true,
    this.size = AppDimensions.iconSizeMedium,
    this.showBadge = false,
    this.badgeLabel,
  }) : type = CustomIconButtonType.redirectInApp,
       onTap = (() => context.go(route));

  CustomIconButton.redirectExternal({
    super.key,
    required this.icon,
    required final String url,
    this.tooltip,
    this.enabled = true,
    this.size = AppDimensions.iconSizeMedium,
    this.showBadge = false,
    this.badgeLabel,
  }) : type = CustomIconButtonType.redirectExternal,
       onTap = (() => safeLaunchUrl(url: Uri.parse(url)));

  final String icon;
  final VoidCallback onTap;
  final double size;
  final String? tooltip;
  final bool enabled;
  final CustomIconButtonType type;
  final bool showBadge;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: CustomIcon(
        iconPath: icon,
        size: size,
        showBadge: showBadge,
        badgeLabel: badgeLabel,
      ),
      tooltip: tooltip,
    );
  }
}

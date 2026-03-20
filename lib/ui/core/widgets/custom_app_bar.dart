import 'package:flutter/material.dart';

import '../themes/dimensions.dart';
import 'custom_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.leading, this.title, this.actions});

  final Widget? leading;
  final String? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        child:
            leading ??
            const CustomIcon(
              iconPath: CustomIcons.appIcon,
              size: AppDimensions.iconSizeMedium,
            ),
      ),
      leadingWidth:
          AppDimensions.iconSizeMedium + AppDimensions.paddingMedium * 2,
      title: title != null ? Text(title!) : null,
      actions: actions,
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
    );
  }
}

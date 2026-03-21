import 'package:flutter/material.dart';

import '../themes/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.centerTitle = false,
  });

  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading != null
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
              ),
              child: leading,
            )
          : null,
      leadingWidth:
          AppDimensions.iconSizeMedium + AppDimensions.paddingMedium * 2,
      title: title != null ? Text(title!) : null,
      actions: actions,
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      centerTitle: centerTitle,
    );
  }
}

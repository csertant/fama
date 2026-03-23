import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/dimensions.dart';

abstract class CustomIcons {
  static const String _basePath = 'assets/icons';

  static const String appIcon = '$_basePath/icon.svg';

  static const String feed = '$_basePath/feed.svg';
  static const String sources = '$_basePath/sources.svg';
  static const String saved = '$_basePath/saved.svg';
  static const String settings = '$_basePath/settings.svg';

  static const String read = '$_basePath/read.svg';
  static const String unread = '$_basePath/unread.svg';

  static const String filter = '$_basePath/filter.svg';
  static const String share = '$_basePath/share.svg';

  static const String add = '$_basePath/add.svg';
  static const String remove = '$_basePath/remove.svg';
  static const String modify = '$_basePath/modify.svg';

  static const String missingImage = '$_basePath/missing_image.svg';
  static const String error = '$_basePath/error.svg';
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key, required this.iconPath, this.size, this.color});

  final String iconPath;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = this.size ?? AppDimensions.of(context).iconSizeDefault;
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? theme.colorScheme.outline,
        BlendMode.srcIn,
      ),
    );
  }
}

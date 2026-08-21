import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

import '../themes/dimensions.dart';

abstract class CustomIcons {
  static const _basePath = 'assets/icons';

  static const appIcon = '$_basePath/icon.svg';

  static const feed = '$_basePath/feed.svg';
  static const sources = '$_basePath/sources.svg';
  static const saved = '$_basePath/saved.svg';
  static const settings = '$_basePath/settings.svg';

  static const refresh = '$_basePath/refresh.svg';
  static const noInternet = '$_basePath/no_internet.svg';

  static const read = '$_basePath/read.svg';
  static const unread = '$_basePath/unread.svg';

  static const check = '$_basePath/check.svg';
  static const checked = '$_basePath/checked.svg';

  static const search = '$_basePath/search.svg';
  static const filter = '$_basePath/filter.svg';
  static const share = '$_basePath/share.svg';

  static const add = '$_basePath/add.svg';
  static const modify = '$_basePath/modify.svg';
  static const remove = '$_basePath/remove.svg';
  static const trash = '$_basePath/trash.svg';

  static const sendMail = '$_basePath/send_mail.svg';

  static const missingImage = '$_basePath/missing_image.svg';
  static const error = '$_basePath/error.svg';
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

import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

class CustomSnackBar {
  static SnackBar info({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    return SnackBar(
      duration: duration,
      content: Text(
        content,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      backgroundColor: theme.colorScheme.onPrimary,
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.buttonLabelOk,
        textColor: theme.colorScheme.primary,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }

  static SnackBar error({
    required BuildContext context,
    required String content,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    return SnackBar(
      duration: duration,
      content: Text(
        content,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onError,
        ),
      ),
      backgroundColor: theme.colorScheme.error,
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.buttonLabelOk,
        textColor: theme.colorScheme.onError,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }
}

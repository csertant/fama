import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import 'custom_snackbar.dart';

void showFeedbackOnResult({
  required BuildContext context,
  required Command<dynamic> action,
  required String successMessage,
  required String errorMessage,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  if (action.completed) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.info(context: context, content: successMessage),
    );
  }

  if (action.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.error(context: context, content: errorMessage),
    );
  }
}

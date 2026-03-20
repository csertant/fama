import 'package:url_launcher/url_launcher.dart';

import 'result.dart';

Future<Result<void>> safeLaunchUrl(final Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    return const Result.ok(null);
  } else {
    return Result.error(Exception('Could not launch $url'));
  }
}

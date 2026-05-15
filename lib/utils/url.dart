import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'result.dart';

Future<Result<void>> safeLaunchUrl({required final Uri url}) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
    return const Result.ok(null);
  } else {
    return Result.error(Exception('Could not launch $url'));
  }
}

Future<Result<void>> safeShareUrl({required final Uri url}) async {
  try {
    await SharePlus.instance.share(ShareParams(uri: url));
    return const Result.ok(null);
  } on Exception catch (e) {
    return Result.error(e);
  }
}

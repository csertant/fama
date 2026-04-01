import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'result.dart';

String normalizeUrl(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return _stripTrailingSlashes(trimmed);
  }
  if (!uri.hasScheme && !uri.hasAuthority) {
    return _stripTrailingSlashes(trimmed);
  }

  final normalizedPath = _stripTrailingSlashes(
    uri.path,
    preserveSingleLeadingSlash: false,
  );
  final normalizedUri = uri.replace(path: normalizedPath);
  final normalized = normalizedUri.toString();

  if (normalizedUri.hasAuthority && normalizedPath.isEmpty) {
    if (normalizedUri.hasQuery || normalizedUri.hasFragment) {
      return normalized.replaceFirst(RegExp('/(?=[?#])'), '');
    }
    return normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
  }

  return normalized;
}

String _stripTrailingSlashes(
  String value, {
  bool preserveSingleLeadingSlash = true,
}) {
  if (value.isEmpty) {
    return value;
  }

  final stripped = value.replaceFirst(RegExp(r'/+$'), '');
  if (stripped.isEmpty && value.startsWith('/') && preserveSingleLeadingSlash) {
    return '/';
  }
  return stripped;
}

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

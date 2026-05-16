import '../../utils/utils.dart';
import 'url_strategies.dart';

class UrlResolver {
  static final List<UrlStrategy> supportedStrategies = [
    BlueSkyUrlStrategy(),
    GithubUrlStrategy(),
    MastodonUrlStrategy(),
    MediumUrlStrategy(),
    RedditUrlStrategy(),
    StackOverflowUrlStrategy(),
    SubstackUrlStrategy(),
    TumblrUrlStrategy(),
    OtherUrlStrategy(),
  ];

  static String resolve(String inputUrl) {
    final cleanedUrl = UrlResolver.cleanUrl(inputUrl);
    for (final strategy in supportedStrategies) {
      if (strategy.canHandle(cleanedUrl)) {
        return strategy.transform(cleanedUrl);
      }
    }
    return cleanedUrl;
  }

  static String cleanUrl(String url) {
    final trimmedUrl = url.trim().replaceAll(RegExp(r'\/+$'), '');
    final parsedUrl = Uri.tryParse(trimmedUrl);
    if (parsedUrl == null) {
      throw ValidationException('Invalid URL format: $url');
    }
    return parsedUrl.toString();
  }
}

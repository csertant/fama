import '../../utils/result.dart';
import '../url_resolver/url_resolver.dart.dart';

class FeedUrlFromPlatformUrlUseCase {
  FeedUrlFromPlatformUrlUseCase();

  Future<Result<String>> execute(String platformUrl) async {
    try {
      final feedUrl = UrlResolver.resolve(platformUrl);
      return Result.ok(feedUrl);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}

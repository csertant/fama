enum Platform {
  bluesky,
  github,
  mastodon,
  medium,
  pinterest,
  reddit,
  stackoverflow,
  substack,
  tumblr,
  other,
}

abstract class UrlStrategy {
  String get iconPath;
  String get platformName;
  Platform get platform;
  bool canHandle(String url);
  String transform(String url);
}

class BlueSkyUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(www\.)?bsky\.app\/profile\/([a-zA-Z0-9_.-]+)',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/bluesky.svg';
  @override
  String get platformName => 'BlueSky';
  @override
  Platform get platform => Platform.bluesky;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('/rss')) {
      return url;
    }
    return '$url/rss';
  }
}

class GithubUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(www\.)?github\.com\/([a-zA-Z0-9_-]+)(?:\/([a-zA-Z0-9._-]+))?\/?$',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/github.svg';
  @override
  String get platformName => 'GitHub';
  @override
  Platform get platform => Platform.github;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    final match = pattern.firstMatch(url);
    if (match == null) {
      return url;
    }
    final user = match.group(2);
    final repo = match.group(3);
    if (repo == null || repo.isEmpty) {
      return 'https://github.com/$user.atom';
    } else {
      return 'https://github.com/$user/$repo/releases.atom';
    }
  }
}

class MastodonUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(www\.)?mastodon\.social\/(@[a-zA-Z0-9_.-]+|tags\/[a-zA-Z0-9_.-]+)\/?',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/mastodon.svg';
  @override
  String get platformName => 'Mastodon';
  @override
  Platform get platform => Platform.mastodon;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('.rss')) {
      return url;
    }
    return '$url.rss';
  }
}

class MediumUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(([a-zA-Z0-9_-]+)\.)?medium\.com\/(@[a-zA-Z0-9_-]+|[a-zA-Z0-9_-]+)?',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/medium.svg';
  @override
  String get platformName => 'Medium';
  @override
  Platform get platform => Platform.medium;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    final uri = Uri.parse(url);
    final host = uri.host.toLowerCase();
    final pathSegments = uri.pathSegments;

    if (host.contains('.') &&
        !host.startsWith('www.') &&
        host.split('.').first != 'medium') {
      final user = host.split('.').first;
      return 'https://medium.com/feed/@$user';
    }

    if (pathSegments.isNotEmpty) {
      final target = pathSegments.first;
      if (target == 'feed') {
        return url;
      }
      return 'https://medium.com/feed/$target';
    }
    return url;
  }
}

class PinterestUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(www\.)?pinterest\.(com|hu)\/([a-zA-Z0-9_-]+)\/?$',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/pinterest.svg';
  @override
  String get platformName => 'Pinterest';
  @override
  Platform get platform => Platform.pinterest;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('feed.rss')) {
      return url;
    }
    return '$url/feed.rss';
  }
}

class RedditUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^(https?:\/\/)?(www\.)?reddit\.com\/(r|user|u)\/[a-zA-Z0-9._-]+\/?',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/reddit.svg';
  @override
  String get platformName => 'Reddit';
  @override
  Platform get platform => Platform.reddit;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('.rss')) {
      return url;
    }
    return '$url/.rss';
  }
}

class StackOverflowUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/(www\.)?stackoverflow\.com\/questions\/tagged\/([a-zA-Z0-9_.-]+)',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/stackoverflow.svg';
  @override
  String get platformName => 'StackOverflow';
  @override
  Platform get platform => Platform.stackoverflow;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    final match = pattern.firstMatch(url);
    if (match != null && match.groupCount >= 2) {
      final tag = match.group(2);
      return 'https://stackoverflow.com/feeds/tag/$tag';
    }
    return url;
  }
}

class SubstackUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/([a-zA-Z0-9_-]+)\.substack\.com\/?',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/substack.svg';
  @override
  String get platformName => 'Substack';
  @override
  Platform get platform => Platform.substack;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('/feed')) {
      return url;
    }
    return '$url/feed';
  }
}

class TumblrUrlStrategy implements UrlStrategy {
  final RegExp pattern = RegExp(
    r'^https?:\/\/([a-zA-Z0-9_-]+)\.tumblr\.com\/?',
    caseSensitive: false,
  );

  @override
  String get iconPath => 'assets/icons/platforms/tumblr.svg';
  @override
  String get platformName => 'Tumblr';
  @override
  Platform get platform => Platform.tumblr;

  @override
  bool canHandle(String url) {
    return pattern.hasMatch(url);
  }

  @override
  String transform(String url) {
    if (url.endsWith('/rss')) {
      return url;
    }
    return '$url/rss';
  }
}

class OtherUrlStrategy implements UrlStrategy {
  @override
  String get iconPath => 'assets/icons/sources.svg';
  @override
  String get platformName => 'Other';
  @override
  Platform get platform => Platform.other;

  @override
  bool canHandle(String url) {
    return true;
  }

  @override
  String transform(String url) {
    return url;
  }
}

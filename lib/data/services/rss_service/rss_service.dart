import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_feed/universal_feed.dart';

import '../../../config/rss_service_config.dart';
import '../../../utils/utils.dart';
import '../connectivity_service/connectivity_service.dart';
import 'models.dart';

class RssService {
  RssService({
    required ConnectivityService connectivityService,
    http.Client? client,
    RssServiceConfig? config,
  }) : _connectivityService = connectivityService,
       _client = client ?? http.Client(),
       _config = config ?? RssServiceConfig.defaults;

  final ConnectivityService _connectivityService;
  final http.Client _client;
  final RssServiceConfig _config;

  Future<Result<ParsedFeed>> fetchFeed({required String url}) async {
    try {
      await _connectivityService.refreshConnectionStatus();
      if (_connectivityService.isOffline) {
        return Result.error(
          NetworkNoInternetException('No internet connection available'),
        );
      }

      final response = await _client
          .get(Uri.parse(url))
          .timeout(_config.requestTimeout);

      if (response.statusCode != 200) {
        return Result.error(
          DataStorageException(
            'Error fetching feed: HTTP ${response.statusCode}',
          ),
        );
      }

      final xmlString = utf8.decode(response.bodyBytes);
      return Result.ok(_parseFeedWithFallback(xmlString));
    } on Exception catch (e) {
      return Result.error(AppException.fromError(e));
    }
  }

  ParsedFeed _parseFeedWithFallback(String xmlString) {
    final parsed = UniversalFeed.tryParse(xmlString);
    if (parsed != null) {
      return _mapToParsedFeed(parsed);
    }

    final sanitizedXml = _sanitizeXml(xmlString);
    final sanitizedParsed = UniversalFeed.tryParse(sanitizedXml);
    if (sanitizedParsed != null) {
      return _mapToParsedFeed(sanitizedParsed);
    }

    throw const FormatException('Failed to parse feed content');
  }

  String _sanitizeXml(String xmlString) {
    final withoutInvalidControlChars = xmlString.replaceAll(
      RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'),
      '',
    );
    return withoutInvalidControlChars.replaceAllMapped(
      RegExp(r'&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9A-Fa-f]+;)'),
      (_) => '&amp;',
    );
  }

  ParsedFeed _mapToParsedFeed(UniversalFeed feed) {
    return ParsedFeed(
      title: feed.title ?? 'Unknown Source',
      siteUrl: _pickSiteUrl(feed),
      imageUrl: feed.image?.url ?? feed.icon?.url,
      description: feed.description,
      copyright: feed.copyright,
      articles: feed.items.map((item) {
        return ParsedArticle(
          guid: item.guid ?? _pickItemUrl(item),
          url: _pickItemUrl(item),
          title: item.title ?? 'Unknown Article',
          summary: item.description,
          content: _pickItemContent(item),
          author: item.authors.map((a) => a.name).toList().join(', '),
          imageUrl: _pickItemImageUrl(item),
          publishedAt: _parsePublishedAt(item.published ?? item.updated),
        );
      }).toList(),
    );
  }

  String? _pickSiteUrl(UniversalFeed feed) {
    final htmlLink = feed.htmlLink?.href;
    if (htmlLink != null && htmlLink.isNotEmpty) {
      return htmlLink;
    }
    final firstNonSelf = feed.links
        .where(
          (link) => link.href.isNotEmpty && link.rel != LinkRelationType.self,
        )
        .map((link) => link.href)
        .firstOrNull;
    if (firstNonSelf != null) {
      return firstNonSelf;
    }
    return feed.xmlLink?.href;
  }

  String _pickItemUrl(Item item) {
    final direct = item.link?.href;
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }
    return item.links
            .where((link) => link.href.isNotEmpty)
            .map((link) => link.href)
            .firstOrNull ??
        '';
  }

  String? _pickItemContent(Item item) {
    final contentValue = item.content
        .map((content) => content.value.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (contentValue.isNotEmpty) {
      return contentValue;
    }
    return item.description;
  }

  DateTime _parsePublishedAt(Timestamp? timestamp) {
    final parsed = timestamp?.parseValue();
    if (parsed != null) {
      return parsed;
    }
    return DateTime.now();
  }

  String? _pickItemImageUrl(Item item) {
    final itemImage = item.image?.url;
    if (itemImage != null && itemImage.isNotEmpty) {
      return itemImage;
    }
    for (final enclosure in item.enclosures) {
      if (enclosure.url.isEmpty) {
        continue;
      }
      final mimeType = enclosure.type.toLowerCase();
      if (mimeType.startsWith('image/')) {
        return enclosure.url;
      }
    }
    return null;
  }
}

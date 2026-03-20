import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_dart/domain/media/thumbnail.dart';
import 'package:uuid/uuid.dart';
import '../../utils/result.dart';

class ParsedFeed {
  ParsedFeed({
    required this.title,
    this.siteUrl,
    this.imageUrl,
    required this.articles,
  });

  final String title;
  final String? siteUrl;
  final String? imageUrl;
  final List<ParsedArticle> articles;
}

class ParsedArticle {
  ParsedArticle({
    required this.guid,
    required this.url,
    required this.title,
    this.content,
    this.imageUrl,
    required this.publishedAt,
  });

  final String guid;
  final String url;
  final String title;
  final String? content;
  final String? imageUrl;
  final DateTime publishedAt;
}

class RssService {
  RssService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Result<ParsedFeed>> fetchFeed(String feedUrl) async {
    try {
      final response = await _client
          .get(Uri.parse(feedUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return Result.error(
          Exception('Error fetching feed: HTTP ${response.statusCode}'),
        );
      }

      final xmlString = utf8.decode(response.bodyBytes);

      if (xmlString.contains('<feed') && !xmlString.contains('<rss')) {
        final atomFeed = AtomFeed.parse(xmlString);
        return Result.ok(_mapAtomToParsedFeed(atomFeed));
      } else {
        final rssFeed = RssFeed.parse(xmlString);
        return Result.ok(_mapRssToParsedFeed(rssFeed));
      }
    } on Exception catch (e) {
      return Result.error(Exception('Error fetching feed: $e'));
    }
  }

  ParsedFeed _mapRssToParsedFeed(RssFeed feed) {
    return ParsedFeed(
      title: feed.title ?? 'Unknown Source',
      siteUrl: feed.link,
      imageUrl: feed.image?.url,
      articles: feed.items.map((item) {
        return ParsedArticle(
          guid: item.guid ?? item.link ?? const Uuid().v1(),
          url: item.link ?? '',
          title: item.title ?? 'Unknown Article',
          content: item.content?.value ?? item.description,
          imageUrl: _extractImageUrlFromRssItem(item),
          publishedAt: DateTime.tryParse(item.pubDate ?? '') ?? DateTime.now(),
        );
      }).toList(),
    );
  }

  ParsedFeed _mapAtomToParsedFeed(AtomFeed feed) {
    return ParsedFeed(
      title: feed.title ?? 'Unknown Source',
      siteUrl: feed.links.isNotEmpty == true ? feed.links.first.href : null,
      imageUrl: feed.logo,
      articles: feed.items.map((item) {
        return ParsedArticle(
          guid: item.id ?? item.links.first.href ?? const Uuid().v1(),
          url: item.links.isNotEmpty == true ? item.links.first.href ?? '' : '',
          title: item.title ?? 'Unknown Article',
          content: item.content ?? item.summary,
          imageUrl: _extractMediaUrl(item.media?.thumbnails),
          publishedAt:
              DateTime.tryParse(item.updated ?? item.published ?? '') ??
              DateTime.now(),
        );
      }).toList(),
    );
  }

  String? _extractImageUrlFromRssItem(RssItem item) {
    if (item.enclosure != null &&
        item.enclosure!.url != null &&
        item.enclosure!.url!.contains('image')) {
      return item.enclosure!.url;
    }
    return null;
  }

  String? _extractMediaUrl(List<Thumbnail>? thumbnails) {
    if (thumbnails != null && thumbnails.isNotEmpty) {
      return thumbnails.first.url;
    }
    return null;
  }
}

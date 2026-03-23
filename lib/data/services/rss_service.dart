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
    this.description,
    this.copyright,
    required this.articles,
  });

  final String title;
  final String? siteUrl;
  final String? imageUrl;
  final String? description;
  final String? copyright;
  final List<ParsedArticle> articles;
}

class ParsedArticle {
  ParsedArticle({
    required this.guid,
    required this.url,
    required this.title,
    this.summary,
    this.content,
    this.author,
    this.imageUrl,
    required this.publishedAt,
  });

  final String guid;
  final String url;
  final String title;
  final String? summary;
  final String? content;
  final String? author;
  final String? imageUrl;
  final DateTime publishedAt;
}

class RssService {
  RssService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Result<ParsedFeed>> fetchFeed({required String url}) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        return Result.error(
          Exception('Error fetching feed: HTTP ${response.statusCode}'),
        );
      }

      final xmlString = utf8.decode(response.bodyBytes);
      return Result.ok(_parseFeedWithFallback(xmlString));
    } on Exception catch (e) {
      return Result.error(Exception('Error fetching feed: $e'));
    }
  }

  ParsedFeed _parseFeedWithFallback(String xmlString) {
    try {
      return _parseFeed(xmlString);
    } on Exception {
      final sanitizedXml = _sanitizeXml(xmlString);
      return _parseFeed(sanitizedXml);
    }
  }

  ParsedFeed _parseFeed(String xmlString) {
    if (xmlString.contains('<feed') && !xmlString.contains('<rss')) {
      final atomFeed = AtomFeed.parse(xmlString);
      return _mapAtomToParsedFeed(atomFeed);
    }

    final rssFeed = RssFeed.parse(xmlString);
    return _mapRssToParsedFeed(rssFeed);
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

  ParsedFeed _mapRssToParsedFeed(RssFeed feed) {
    return ParsedFeed(
      title: feed.title ?? 'Unknown Source',
      siteUrl: feed.link,
      imageUrl: feed.image?.url,
      description: feed.description,
      copyright: feed.copyright,
      articles: feed.items.map((item) {
        return ParsedArticle(
          guid: item.guid ?? item.link ?? const Uuid().v1(),
          url: item.link ?? '',
          title: item.title ?? 'Unknown Article',
          summary: item.description,
          content: item.content?.value ?? item.description,
          author: item.author,
          imageUrl: _extractImageUrlFromRssItem(item),
          publishedAt: _parsePublishedAt(item.pubDate),
        );
      }).toList(),
    );
  }

  ParsedFeed _mapAtomToParsedFeed(AtomFeed feed) {
    return ParsedFeed(
      title: feed.title ?? 'Unknown Source',
      siteUrl: feed.links.isNotEmpty == true ? feed.links.first.href : null,
      imageUrl: feed.logo,
      description: feed.subtitle,
      copyright: feed.rights,
      articles: feed.items.map((item) {
        return ParsedArticle(
          guid: item.id ?? item.links.first.href ?? const Uuid().v1(),
          url: item.links.isNotEmpty == true ? item.links.first.href ?? '' : '',
          title: item.title ?? 'Unknown Article',
          summary: item.summary,
          content: item.content ?? item.summary,
          author: item.authors.isNotEmpty == true
              ? item.authors.first.name
              : null,
          imageUrl: _extractMediaUrl(item.media?.thumbnails),
          publishedAt: _parsePublishedAt(item.updated ?? item.published),
        );
      }).toList(),
    );
  }

  DateTime _parsePublishedAt(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return DateTime.now();
    }
    final dateValue = rawDate.trim();
    final isoDate = DateTime.tryParse(dateValue);
    if (isoDate != null) {
      return isoDate;
    }
    final rfcDate = _tryParseRfc822Date(dateValue);
    if (rfcDate != null) {
      return rfcDate;
    }
    return DateTime.now();
  }

  DateTime? _tryParseRfc822Date(String value) {
    final match = RegExp(
      r'^(?:[A-Za-z]{3},\s*)?(\d{1,2})\s([A-Za-z]{3})\s(\d{4})\s(\d{2}):(\d{2})(?::(\d{2}))?\s([+-]\d{4}|GMT|UTC|UT)$',
    ).firstMatch(value);
    if (match == null) {
      return null;
    }
    final monthByName = <String, String>{
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };
    final day = match.group(1)!.padLeft(2, '0');
    final month = monthByName[match.group(2)!];
    if (month == null) {
      return null;
    }
    final year = match.group(3)!;
    final hour = match.group(4)!;
    final minute = match.group(5)!;
    final second = (match.group(6) ?? '00').padLeft(2, '0');
    final zone = match.group(7)!;
    final isoZone = switch (zone) {
      'GMT' || 'UTC' || 'UT' => 'Z',
      _ => '${zone.substring(0, 3)}:${zone.substring(3, 5)}',
    };
    final isoDateString = '$year-$month-${day}T$hour:$minute:$second$isoZone';
    return DateTime.tryParse(isoDateString);
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

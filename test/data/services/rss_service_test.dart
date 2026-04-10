import 'dart:convert';

import 'package:fama/data/services/rss_service/models.dart';
import 'package:fama/data/services/rss_service/rss_service.dart';
import 'package:fama/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'mock_connectivity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RssService.fetchFeed', () {
    test('parses malformed RSS by sanitizing invalid entities', () async {
      const malformedXml = '''
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:telex="https://telex.hu/rss/" version="2.0">
  <channel>
    <title>Telex RSS: Legfrissebb</title>
    <link>https://telex.hu/rss</link>
    <description>Articles from AT&T News</description>
    <item>
      <title>Sample item with R&D</title>
      <link>https://telex.hu/sample</link>
      <pubDate>Mon, 23 Mar 2026 21:28:49 +0100</pubDate>
      <author>Example Author</author>
      <description>Summary with broken &entity;</description>
      <enclosure url="https://assets.telex.hu/sample.jpg" type="image/jpeg" length="0"/>
      <content:encoded/>
      <telex:slug>sample</telex:slug>
    </item>
  </channel>
</rss>
''';

      final client = MockClient((_) async {
        return http.Response.bytes(
          utf8.encode(malformedXml),
          200,
          headers: {'content-type': 'application/rss+xml; charset=utf-8'},
        );
      });

      final service = RssService(
        client: client,
        connectivityService: MockConnectivityService(),
      );
      final result = await service.fetchFeed(url: 'https://telex.hu/rss');

      expect(result, isA<Ok<ParsedFeed>>());
      switch (result) {
        case Ok<ParsedFeed>():
          expect(result.value.title, 'Telex RSS: Legfrissebb');
          expect(result.value.articles, hasLength(1));
          expect(result.value.articles.first.title, 'Sample item with R&D');
          expect(result.value.articles.first.url, 'https://telex.hu/sample');
          expect(
            result.value.articles.first.publishedAt.toUtc(),
            DateTime.utc(2026, 3, 23, 20, 28, 49),
          );
        case Error<ParsedFeed>():
          fail('Expected successful parse, got ${result.error}');
      }
    });

    test('extracts item image from media:thumbnail (BBC style feed)', () async {
      const mediaThumbnailXml = '''
<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:media="http://search.yahoo.com/mrss/" version="2.0">
  <channel>
    <title>BBC News</title>
    <link>https://www.bbc.co.uk/news</link>
    <description>BBC News feed</description>
    <item>
      <title>Headline</title>
      <link>https://www.bbc.com/news/articles/example</link>
      <guid isPermaLink="false">https://www.bbc.com/news/articles/example#0</guid>
      <pubDate>Fri, 10 Apr 2026 15:12:57 GMT</pubDate>
      <media:thumbnail width="240" height="134" url="https://ichef.bbci.co.uk/ace/standard/240/cpsprodpb/example.jpg"/>
    </item>
  </channel>
</rss>
''';

      final client = MockClient((_) async {
        return http.Response.bytes(
          utf8.encode(mediaThumbnailXml),
          200,
          headers: {'content-type': 'application/rss+xml; charset=utf-8'},
        );
      });

      final service = RssService(
        client: client,
        connectivityService: MockConnectivityService(),
      );
      final result = await service.fetchFeed(
        url: 'https://feeds.bbci.co.uk/news/rss.xml',
      );

      expect(result, isA<Ok<ParsedFeed>>());
      switch (result) {
        case Ok<ParsedFeed>():
          expect(result.value.articles, hasLength(1));
          expect(
            result.value.articles.first.imageUrl,
            'https://ichef.bbci.co.uk/ace/standard/240/cpsprodpb/example.jpg',
          );
        case Error<ParsedFeed>():
          fail('Expected successful parse, got ${result.error}');
      }
    });
  });
}

import 'package:fama/utils/url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeUrl', () {
    test('removes trailing slash from host root', () {
      expect(normalizeUrl('https://example.com/'), 'https://example.com');
    });

    test('removes repeated trailing slashes from path', () {
      expect(
        normalizeUrl('https://example.com/feed///'),
        'https://example.com/feed',
      );
    });

    test('keeps query and fragment when normalizing', () {
      expect(
        normalizeUrl('https://example.com/feed/?a=1#latest'),
        'https://example.com/feed?a=1#latest',
      );
    });

    test('trims surrounding whitespace', () {
      expect(
        normalizeUrl('  https://example.com/feed/  '),
        'https://example.com/feed',
      );
    });

    test('keeps slash-only value stable', () {
      expect(normalizeUrl('/'), '/');
    });
  });
}

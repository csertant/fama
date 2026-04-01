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

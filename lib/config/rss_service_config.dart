class RssServiceConfig {
  const RssServiceConfig({this.requestTimeout = const Duration(seconds: 15)});

  static const RssServiceConfig defaults = RssServiceConfig();

  final Duration requestTimeout;
}

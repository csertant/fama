class RemoteDataServiceConfig {
  const RemoteDataServiceConfig({
    required this.recommendationsUrl,
    this.requestTimeout = const Duration(seconds: 15),
    required this.schemaVersion,
  });

  static const RemoteDataServiceConfig defaults = RemoteDataServiceConfig(
    recommendationsUrl: 'https://csertant.github.io/fama-config/sources.json',
    schemaVersion: 1,
  );

  final String recommendationsUrl;
  final Duration requestTimeout;
  final int schemaVersion;
}

class RemoteDataServiceConfig {
  const RemoteDataServiceConfig({
    required this.recommendationsUrl,
    this.requestTimeout = const Duration(seconds: 15),
  });

  static const RemoteDataServiceConfig defaults = RemoteDataServiceConfig(
    recommendationsUrl: 'https://csertant.github.io/fama-config/sources.json',
  );

  final String recommendationsUrl;
  final Duration requestTimeout;
}

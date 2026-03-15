import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart' as http_retry;

typedef Json = Map<String, dynamic>;
typedef Headers = Map<String, String>;
typedef Parameters = Map<String, String>;

class CustomHttpClient {
  CustomHttpClient({
    required this.host,
    required this.apiRoute,
    this.commonHeaders = const {},
    this.getHeaders = const {},
    this.postHeaders = const {},
    this.putHeaders = const {},
    final int maxRetryNumber = 3,
    final Duration retryDelay = const Duration(seconds: 1),
  }) {
    client = http_retry.RetryClient(
      client,
      retries: maxRetryNumber,
      when: (final response) =>
          _retriableStatusCodes.contains(response.statusCode),
      delay: (final _) => retryDelay,
    );
  }
  final String host;
  final String apiRoute;
  final Headers commonHeaders;
  final Headers getHeaders;
  final Headers postHeaders;
  final Headers putHeaders;

  final List<int> _retriableStatusCodes = [500, 502, 503, 504];

  late final http.Client client;

  Future<http.Response> get<U>({
    required final String endpoint,
    final Parameters parameters = const {},
    final Headers headers = const {},
  }) {
    return client.get(
      Uri.https(host, '$apiRoute$endpoint', parameters),
      headers: {...commonHeaders, ...getHeaders, ...headers},
    );
  }

  Future<http.Response> post<U>({
    required final String endpoint,
    final Parameters parameters = const {},
    final Headers headers = const {},
    Object? body,
    final Json? json,
  }) {
    assert(body == null || json == null, 'Cannot provide both body and json.');
    if (json != null) {
      body = jsonEncode(json);
      headers.addAll({'content-type': 'application/json'});
    }
    return client.post(
      Uri.https(host, '$apiRoute$endpoint', parameters),
      headers: {...commonHeaders, ...postHeaders, ...headers},
      body: body,
    );
  }

  Future<http.Response> put<U>({
    required final String endpoint,
    final Parameters parameters = const {},
    final Headers headers = const {},
    Object? body,
    final Json? json,
  }) {
    assert(body == null || json == null, 'Cannot provide both body and json.');
    if (json != null) {
      body = jsonEncode(json);
      headers.addAll({'content-type': 'application/json'});
    }
    return client.put(
      Uri.https(host, '$apiRoute$endpoint', parameters),
      headers: {...commonHeaders, ...putHeaders, ...headers},
      body: body,
    );
  }
}

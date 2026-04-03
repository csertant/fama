import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/remote_data_service_config.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/result.dart';
import '../../../utils/types.dart';
import 'models.dart';

class RemoteDataService {
  RemoteDataService({http.Client? client, RemoteDataServiceConfig? config})
    : _client = client ?? http.Client(),
      _config = config ?? RemoteDataServiceConfig.defaults;

  final http.Client _client;
  final RemoteDataServiceConfig _config;

  Future<Result<List<SourceRecommendation>>>
  fetchSourceRecommendations() async {
    try {
      final response = await _client
          .get(Uri.parse(_config.recommendationsUrl))
          .timeout(_config.requestTimeout);

      if (response.statusCode != 200) {
        return Result.error(
          RemoteDataException(
            'Error fetching recommendations: HTTP ${response.statusCode}',
          ),
        );
      }
      final jsonString = utf8.decode(response.bodyBytes);
      final recommendations = _parseRecommendations(jsonString);
      return Result.ok(recommendations);
    } on Exception catch (e) {
      return Result.error(
        RemoteDataException('Error fetching recommendations: $e'),
      );
    }
  }

  List<SourceRecommendation> _parseRecommendations(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      if (decoded is! JsonMap) {
        throw ValidationException(
          'Recommendations payload must be a JSON object.',
        );
      }

      final version = decoded['version'];
      if (version is! num || version.toInt() != _config.schemaVersion) {
        return [];
      }

      final recommendations = SourceRecommendations.fromJson(decoded);
      return recommendations.sources;
    } on Exception catch (e) {
      throw RemoteDataException('Error parsing recommendations: $e');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/remote_data_service_config.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/result.dart';
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
      final recommendations = SourceRecommendations.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
      //TODO: check version compatibility
      return recommendations.sources;
    } on Exception catch (e) {
      throw RemoteDataException('Error parsing recommendations: $e');
    }
  }
}

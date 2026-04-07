import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/remote_data_service_config.dart';
import '../../../utils/utils.dart';
import '../connectivity_service/connectivity_service.dart';
import 'models.dart';

class RemoteDataService {
  RemoteDataService({
    required ConnectivityService connectivityService,
    http.Client? client,
    RemoteDataServiceConfig? config,
  }) : _connectivityService = connectivityService,
       _client = client ?? http.Client(),
       _config = config ?? RemoteDataServiceConfig.defaults;

  final ConnectivityService _connectivityService;
  final http.Client _client;
  final RemoteDataServiceConfig _config;

  Future<Result<List<SourceRecommendation>>>
  fetchSourceRecommendations() async {
    try {
      await _connectivityService.refreshConnectionStatus();
      if (_connectivityService.isOffline) {
        return Result.error(
          NetworkNoInternetException('No internet connection available'),
        );
      }

      final response = await _client
          .get(Uri.parse(_config.recommendationsUrl))
          .timeout(_config.requestTimeout);

      if (response.statusCode != 200) {
        return Result.error(
          DataStorageException(
            'Error fetching recommendations: HTTP ${response.statusCode}',
          ),
        );
      }

      final jsonString = utf8.decode(response.bodyBytes);
      final recommendations = _parseRecommendations(jsonString);
      return Result.ok(recommendations);
    } on Exception catch (e) {
      return Result.error(AppException.fromError(e));
    }
  }

  List<SourceRecommendation> _parseRecommendations(String jsonString) {
    final decoded = json.decode(jsonString);
    if (decoded is! JsonMap) {
      throw const FormatException(
        'Recommendations payload must be a JSON object.',
      );
    }
    final version = decoded['version'];
    if (version is! num || version.toInt() != _config.schemaVersion) {
      return [];
    }
    final recommendations = SourceRecommendations.fromJson(decoded);
    return recommendations.sources;
  }
}

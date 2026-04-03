import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/source/source_repository.dart';
import '../../data/services/remote_data_service/models.dart';
import '../../utils/utils.dart';

class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel({
    required SourceRepository sourceRepository,
    required SessionManager sessionManager,
  }) : _sourceRepository = sourceRepository,
       _sessionManager = sessionManager {
    load = Command0(_load);
    subscribeToSource = Command1(_subscribeToSource);

    _sessionManager.addListener(_onSessionChanged);
    _sourcesSubscription = _sourceRepository
        .watchSourcesForProfile(profileId: _sessionManager.profileId!)
        .listen((sources) {
          _subscribedSources = sources;
          notifyListeners();
        });

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final SourceRepository _sourceRepository;
  late final StreamSubscription<List<Source>> _sourcesSubscription;

  List<Source> _subscribedSources = [];
  List<SourceRecommendation> _sourceRecommendations = [];

  late Command0<void> load;
  late Command1<void, String> subscribeToSource;

  List<Source> get subscribedSources =>
      UnmodifiableListView(_subscribedSources);
  List<SourceRecommendation> get sourceRecommendations =>
      UnmodifiableListView(_sourceRecommendations);

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(
          LocalDataNotFoundException('No active profile session found'),
        );
      }
      final sourcesResult = await _sourceRepository.getSourcesForProfile(
        profileId: profileId,
      );
      switch (sourcesResult) {
        case Ok<List<Source>>():
          _subscribedSources = sourcesResult.value;
        case Error<List<Source>>():
          return sourcesResult;
      }
      final sourceRecommendationsResult = await _sourceRepository
          .getSourceRecommendations();
      switch (sourceRecommendationsResult) {
        case Ok<List<SourceRecommendation>>():
          _sourceRecommendations = sourceRecommendationsResult.value;
        case Error<List<SourceRecommendation>>():
          return sourceRecommendationsResult;
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  void _onSessionChanged() {
    unawaited(load.execute());
  }

  Future<Result<void>> _subscribeToSource(String url) async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(
          LocalDataNotFoundException('No active profile session found'),
        );
      }
      final subscribeResult = await _sourceRepository.saveSource(
        profileId: profileId,
        url: url,
      );
      switch (subscribeResult) {
        case Ok<void>():
          return const Result.ok(null);
        case Error<void>():
          return subscribeResult;
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _sourcesSubscription.cancel();
    super.dispose();
  }
}

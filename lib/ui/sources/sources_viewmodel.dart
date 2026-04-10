import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/source/source_repository.dart';
import '../../utils/utils.dart';

class SourcesViewModel extends ChangeNotifier {
  SourcesViewModel({
    required SourceRepository sourceRepository,
    required SessionManager sessionManager,
  }) : _sourceRepository = sourceRepository,
       _sessionManager = sessionManager {
    load = Command0(_load);
    removeSource = Command1(_removeSource);

    _sessionManager.addListener(_onSessionChanged);
    _sourcesSubscription = _sourceRepository
        .watchSourcesForProfile(profileId: _sessionManager.profileId!)
        .listen(_onSourcesChanged);

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final SourceRepository _sourceRepository;
  StreamSubscription<List<Source>>? _sourcesSubscription;

  List<Source> _sources = [];

  late Command0<void> load;
  late Command1<void, Source> removeSource;

  List<Source> get sources => UnmodifiableListView(_sources);

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(
          DataNotFoundException('No active profile session found'),
        );
      }
      final sourcesResult = await _sourceRepository.getSourcesForProfile(
        profileId: profileId,
      );
      switch (sourcesResult) {
        case Ok<List<Source>>():
          _sources = sourcesResult.value;
          return const Result.ok(null);
        case Error<List<Source>>():
          return sourcesResult;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _onSessionChanged() async {
    await _sourcesSubscription?.cancel();
    _sourcesSubscription = _sourceRepository
        .watchSourcesForProfile(profileId: _sessionManager.profileId!)
        .listen(_onSourcesChanged);
    unawaited(load.execute());
  }

  void _onSourcesChanged(List<Source> sources) {
    _sources = sources;
    notifyListeners();
  }

  Future<Result<void>> _removeSource(Source source) async {
    try {
      return await _sourceRepository.removeSource(
        profileId: source.profileId,
        sourceId: source.id,
      );
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _sourcesSubscription?.cancel();
    super.dispose();
  }
}

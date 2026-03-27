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
    modifySource = Command1(_modifySource);
    removeSource = Command1(_removeSource);

    _sessionManager.addListener(_onSessionChanged);
    _sourcesSubscription = _sourceRepository
        .watchSourcesForProfile(profileId: _sessionManager.profileId!)
        .listen((sources) {
          _sources = sources;
          notifyListeners();
        });

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final SourceRepository _sourceRepository;
  late final StreamSubscription<List<Source>> _sourcesSubscription;

  List<Source> _sources = [];

  late Command0<void> load;
  late Command1<void, Source> modifySource;
  late Command1<void, Source> removeSource;

  List<Source> get sources => UnmodifiableListView(_sources);

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
          _sources = sourcesResult.value;
          return const Result.ok(null);
        case Error<List<Source>>():
          return sourcesResult;
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  void _onSessionChanged() {
    unawaited(load.execute());
  }

  Future<Result<void>> _modifySource(Source source) async {
    final saveResult = await _sourceRepository.modifySource(
      profileId: source.profileId,
      source: source,
    );
    switch (saveResult) {
      case Ok<void>():
        return const Result.ok(null);
      case Error<void>():
        return saveResult;
    }
  }

  Future<Result<void>> _removeSource(Source source) async {
    final removeResult = await _sourceRepository.removeSource(
      profileId: source.profileId,
      sourceId: source.id,
    );
    switch (removeResult) {
      case Ok<void>():
        return const Result.ok(null);
      case Error<void>():
        return removeResult;
    }
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _sourcesSubscription.cancel();
    super.dispose();
  }
}

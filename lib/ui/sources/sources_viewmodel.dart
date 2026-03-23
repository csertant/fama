import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/repositories/source/source_repository.dart';
import '../../utils/utils.dart';

class SourcesViewModel extends ChangeNotifier {
  SourcesViewModel({required SourceRepository sourceRepository})
    : _sourceRepository = sourceRepository {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final SourceRepository _sourceRepository;
  List<Source> _sources = [];

  late Command0<void> load;

  List<Source> get sources => UnmodifiableListView(_sources);

  Future<Result<void>> _load() async {
    try {
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> modifySource(Source source) async {
    await _sourceRepository.saveSource(
      profileId: source.profileId,
      url: source.url,
    );
    return const Result.ok(null);
  }

  Future<Result<void>> removeSource(Source source) async {
    await _sourceRepository.removeSource(
      profileId: source.profileId,
      sourceId: source.id,
    );
    return const Result.ok(null);
  }
}

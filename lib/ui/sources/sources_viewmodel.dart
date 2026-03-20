import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/repositories/source/source_repository.dart';
import '../../utils/utils.dart';

class SourcesViewModel extends ChangeNotifier {
  SourcesViewModel({required SourceRepository sourceRepository})
    : _sourceRepository = sourceRepository {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final SourceRepository _sourceRepository;

  late Command0<void> load;

  Future<Result<void>> _load() async {
    try {
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}

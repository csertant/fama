import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/repositories/settings/settings_repository.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final SettingsRepository _settingsRepository;

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

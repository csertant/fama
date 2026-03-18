import 'package:flutter/material.dart';

import '../../data/repositories/settings/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository;

  final SettingsRepository _settingsRepository;
}

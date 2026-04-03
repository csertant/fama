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

  final Set<String> _selectedLanguages = {};
  final Set<String> _selectedCountries = {};
  final Set<String> _selectedCategories = {};
  bool _showSubscribed = false;

  late Command0<void> load;
  late Command1<void, String> subscribeToSource;

  List<Source> get subscribedSources =>
      UnmodifiableListView(_subscribedSources);
  List<SourceRecommendation> get sourceRecommendations =>
      UnmodifiableListView(_sourceRecommendations);
  List<SourceRecommendation> get filteredRecommendations {
    return _sourceRecommendations.where((rec) {
      final matchesLanguage =
          _selectedLanguages.isEmpty ||
          _selectedLanguages.contains(rec.language);
      final matchesCountry =
          _selectedCountries.isEmpty ||
          _selectedCountries.contains(rec.country);
      final matchesCategory =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(rec.category);
      final matchesShowSubscribed =
          _showSubscribed ||
          !_subscribedSources.any((source) => source.url == rec.url);
      return matchesLanguage &&
          matchesCountry &&
          matchesCategory &&
          matchesShowSubscribed;
    }).toList();
  }

  List<String> get selectedLanguages =>
      UnmodifiableListView(_selectedLanguages);
  List<String> get availableLanguages {
    final values =
        _sourceRecommendations.map((rec) => rec.language).toSet().toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  List<String> get selectedCountries =>
      UnmodifiableListView(_selectedCountries);
  List<String> get availableCountries {
    final values =
        _sourceRecommendations
            .map((rec) => rec.country.toUpperCase())
            .toSet()
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  List<String> get selectedCategories =>
      UnmodifiableListView(_selectedCategories);
  List<String> get availableCategories {
    final values =
        _sourceRecommendations.map((rec) => rec.category).toSet().toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  bool get showSubscribed => _showSubscribed;

  bool get hasActiveFilters =>
      _selectedLanguages.isNotEmpty ||
      _selectedCountries.isNotEmpty ||
      _selectedCategories.isNotEmpty;
  int get activeFiltersCount =>
      _selectedLanguages.length +
      _selectedCountries.length +
      _selectedCategories.length;

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

  void toggleLanguageFilter(String language) {
    if (_selectedLanguages.contains(language)) {
      _selectedLanguages.remove(language);
    } else {
      _selectedLanguages.add(language);
    }
    notifyListeners();
  }

  void toggleCountryFilter(String country) {
    if (_selectedCountries.contains(country)) {
      _selectedCountries.remove(country);
    } else {
      _selectedCountries.add(country);
    }
    notifyListeners();
  }

  void toggleCategoryFilter(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleShowSubscribed() {
    _showSubscribed = !_showSubscribed;
    notifyListeners();
  }

  void clearFilters() {
    _selectedLanguages.clear();
    _selectedCountries.clear();
    _selectedCategories.clear();
    _showSubscribed = false;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _sourcesSubscription.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import '../../../data/database/database.dart';
import '../widgets/widgets.dart';

mixin ArticleFilterMixin on ChangeNotifier {
  final Set<String> _selectedSources = {};
  final Set<String> _selectedAuthors = {};
  bool _showRead = false;
  Duration _selectedDuration = FilterDuration.defaultDuration;

  bool _filterCacheDirty = true;
  bool _sourcesCacheDirty = true;
  bool _authorsCacheDirty = true;

  List<Article> _cachedFilteredArticles = [];
  List<String> _cachedAvailableSources = [];
  List<String> _cachedAvailableAuthors = [];

  List<Article> get baseFilterArticles;

  void invalidateFilterData() {
    _filterCacheDirty = true;
    _sourcesCacheDirty = true;
    _authorsCacheDirty = true;
  }

  List<Article> get filteredArticles {
    if (_filterCacheDirty) {
      final now = DateTime.now();
      _cachedFilteredArticles = baseFilterArticles.where((article) {
        final matchesSource =
            _selectedSources.isEmpty ||
            _selectedSources.contains(article.sourceName);
        final matchesAuthor =
            _selectedAuthors.isEmpty ||
            _selectedAuthors.any((selected) {
              final rawAuthor = article.author?.trim();
              if (rawAuthor == null || rawAuthor.isEmpty) {
                return false;
              }
              final authorParts = rawAuthor.split(RegExp(r',\s*'));
              return authorParts.any(
                (part) => part.trim().toLowerCase() == selected.toLowerCase(),
              );
            });
        final matchesReadStatus = _showRead || !article.isRead;
        final matchesDuration =
            now.difference(article.publishedAt) <= _selectedDuration;
        return matchesSource &&
            matchesAuthor &&
            matchesReadStatus &&
            matchesDuration;
      }).toList();
      _filterCacheDirty = false;
    }
    return _cachedFilteredArticles;
  }

  List<String> get availableSources {
    if (_sourcesCacheDirty) {
      _cachedAvailableSources =
          baseFilterArticles.map((rec) => rec.sourceName).toSet().toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      _sourcesCacheDirty = false;
    }
    return _cachedAvailableSources;
  }

  List<String> get availableAuthors {
    if (_authorsCacheDirty) {
      final lowerCaseTracker = <String>{};
      final authorsSet = <String>{};
      for (final article in baseFilterArticles) {
        final rawAuthor = article.author?.trim();
        if (rawAuthor != null && rawAuthor.isNotEmpty) {
          final authorParts = rawAuthor.split(RegExp(r',\s*'));
          for (final part in authorParts) {
            final cleaned = part.trim();
            final isNew = !lowerCaseTracker.contains(cleaned.toLowerCase());
            if (cleaned.isNotEmpty && isNew) {
              lowerCaseTracker.add(cleaned.toLowerCase());
              authorsSet.add(cleaned);
            }
          }
        }
      }
      _cachedAvailableAuthors = authorsSet.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      _authorsCacheDirty = false;
    }
    return _cachedAvailableAuthors;
  }

  List<String> get selectedSources => _selectedSources.toList();
  List<String> get selectedAuthors => _selectedAuthors.toList();
  bool get showRead => _showRead;
  Duration get selectedDuration => _selectedDuration;

  void toggleSourceFilter(String source) {
    if (_selectedSources.contains(source)) {
      _selectedSources.remove(source);
    } else {
      _selectedSources.add(source);
    }
    _filterCacheDirty = true;
    notifyListeners();
  }

  void toggleAuthorFilter(String author) {
    if (_selectedAuthors.contains(author)) {
      _selectedAuthors.remove(author);
    } else {
      _selectedAuthors.add(author);
    }
    _filterCacheDirty = true;
    notifyListeners();
  }

  void toggleShowRead() {
    _showRead = !_showRead;
    _filterCacheDirty = true;
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _selectedDuration = duration;
    _filterCacheDirty = true;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSources.clear();
    _selectedAuthors.clear();
    _showRead = false;
    _selectedDuration = FilterDuration.defaultDuration;
    _filterCacheDirty = true;
    notifyListeners();
  }
}

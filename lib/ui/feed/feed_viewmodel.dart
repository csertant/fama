import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../utils/utils.dart';
import '../core/widgets/widgets.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({
    required ArticleRepository articleRepository,
    required SessionManager sessionManager,
  }) : _sessionManager = sessionManager,
       _articleRepository = articleRepository {
    load = Command0(_load);
    markAsSaved = Command1(_markAsSaved);
    markAsRead = Command1(_markAsRead);

    _sessionManager.addListener(_onSessionChanged);
    _articlesSubscription = _articleRepository
        .watchArticles(profileId: _sessionManager.profileId!)
        .listen((articles) {
          _articles = articles;
          notifyListeners();
        });

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  late final StreamSubscription<List<Article>> _articlesSubscription;

  List<Article> _articles = [];

  final Set<String> _selectedSources = {};
  final Set<String> _selectedAuthors = {};
  bool _showRead = false;
  int _selectedLimit = FilterLimit.defaultLimit;
  Duration _selectedDuration = FilterDuration.defaultDuration;

  late Command0<void> load;
  late Command1<void, Article> markAsSaved;
  late Command1<void, Article> markAsRead;

  List<Article> get articles => UnmodifiableListView(_articles);
  List<Article> get filteredArticles {
    final now = DateTime.now();
    return _articles
        .where((article) {
          final matchesSource =
              _selectedSources.isEmpty ||
              _selectedSources.contains(article.sourceName);
          final matchesAuthor =
              _selectedAuthors.isEmpty ||
              _selectedAuthors.contains(article.author);
          final matchesReadStatus = _showRead || !article.isRead;
          final matchesDuration =
              now.difference(article.publishedAt) <= _selectedDuration;
          return matchesSource &&
              matchesAuthor &&
              matchesReadStatus &&
              matchesDuration;
        })
        .take(_selectedLimit)
        .toList();
  }

  List<String> get selectedSources => UnmodifiableListView(_selectedSources);
  List<String> get availableSources {
    final values = _articles.map((rec) => rec.sourceName).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  List<String> get selectedAuthors => UnmodifiableListView(_selectedAuthors);
  List<String> get availableAuthors {
    final values =
        _articles
            .map((rec) => rec.author?.trim())
            .whereType<String>()
            .where((author) => author.isNotEmpty)
            .toSet()
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  bool get showRead => _showRead;
  int get selectedLimit => _selectedLimit;
  Duration get selectedDuration => _selectedDuration;

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(DataNotFoundException('No active session found'));
      }
      final syncResult = await _articleRepository.syncArticlesForProfile(
        profileId: profileId,
      );
      switch (syncResult) {
        case Ok<void>():
          final articlesResult = await _articleRepository.getArticles(
            profileId: profileId,
          );
          switch (articlesResult) {
            case Ok<List<Article>>():
              _articles = articlesResult.value;
              return const Result.ok(null);
            case Error<List<Article>>():
              return Result.error(articlesResult.error);
          }
        case Error<void>():
          return syncResult;
      }
    } finally {
      notifyListeners();
    }
  }

  void _onSessionChanged() {
    unawaited(load.execute());
  }

  Future<Result<void>> _markAsSaved(Article article) async {
    try {
      return await _articleRepository.markAsSaved(
        profileId: article.profileId,
        articleId: article.id,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _markAsRead(Article article) async {
    try {
      return await _articleRepository.markAsRead(
        profileId: article.profileId,
        articleId: article.id,
      );
    } finally {
      notifyListeners();
    }
  }

  void toggleSourceFilter(String source) {
    if (_selectedSources.contains(source)) {
      _selectedSources.remove(source);
    } else {
      _selectedSources.add(source);
    }
    notifyListeners();
  }

  void toggleAuthorFilter(String author) {
    if (_selectedAuthors.contains(author)) {
      _selectedAuthors.remove(author);
    } else {
      _selectedAuthors.add(author);
    }
    notifyListeners();
  }

  void toggleShowRead() {
    _showRead = !_showRead;
    notifyListeners();
  }

  void setLimit(int limit) {
    _selectedLimit = limit;
    notifyListeners();
  }

  void setDuration(Duration duration) {
    _selectedDuration = duration;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSources.clear();
    _selectedAuthors.clear();
    _showRead = false;
    _selectedLimit = FilterLimit.defaultLimit;
    _selectedDuration = FilterDuration.defaultDuration;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _articlesSubscription.cancel();
    super.dispose();
  }
}

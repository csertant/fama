import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../utils/utils.dart';
import '../core/mixins/article_filter_mixin.dart';

class SavedViewModel extends ChangeNotifier with ArticleFilterMixin {
  SavedViewModel({
    required ArticleRepository articleRepository,
    required SessionManager sessionManager,
  }) : _articleRepository = articleRepository,
       _sessionManager = sessionManager {
    load = Command0(_load);
    markAsUnsaved = Command1(_markAsUnsaved);
    markAsRead = Command1(_markAsRead);

    _sessionManager.addListener(_onSessionChanged);
    _savedArticlesSubscription = _articleRepository
        .watchSavedArticles(profileId: _sessionManager.profileId!)
        .listen(_onSavedArticlesChanged);

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  StreamSubscription<List<Article>>? _savedArticlesSubscription;

  List<Article> _savedArticles = [];

  @override
  List<Article> get baseFilterArticles => _savedArticles;

  late Command0<void> load;
  late Command1<void, Article> markAsUnsaved;
  late Command1<void, Article> markAsRead;

  List<Article> get savedArticles => UnmodifiableListView(_savedArticles);
  List<Article> get filteredSavedArticles => filteredArticles;

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(DataNotFoundException('No active session found'));
      }
      final savedArticlesResult = await _articleRepository.getSavedArticles(
        profileId: profileId,
      );
      switch (savedArticlesResult) {
        case Ok<List<Article>>():
          invalidateFilterData();
          _savedArticles = savedArticlesResult.value;
          return const Result.ok(null);
        case Error<List<Article>>():
          return Result.error(savedArticlesResult.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _onSessionChanged() async {
    await _savedArticlesSubscription?.cancel();
    _savedArticlesSubscription = _articleRepository
        .watchSavedArticles(profileId: _sessionManager.profileId!)
        .listen(_onSavedArticlesChanged);
    unawaited(load.execute());
  }

  void _onSavedArticlesChanged(List<Article> savedArticles) {
    _savedArticles = savedArticles;
    invalidateFilterData();
    notifyListeners();
  }

  Future<Result<void>> _markAsUnsaved(Article article) async {
    try {
      final result = await _articleRepository.markAsUnsaved(
        profileId: article.profileId,
        articleId: article.id,
      );
      if (result is Ok<void>) {
        _savedArticles.removeWhere(
          (savedArticle) => savedArticle.id == article.id,
        );
        invalidateFilterData();
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _markAsRead(Article article) async {
    try {
      final result = await _articleRepository.markAsRead(
        profileId: article.profileId,
        articleId: article.id,
      );
      if (result is Ok<void>) {
        _updateLocalSavedArticle(articleId: article.id, isRead: true);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _updateLocalSavedArticle({
    required Id articleId,
    bool? isRead,
    bool? isSaved,
  }) {
    final index = _savedArticles.indexWhere(
      (article) => article.id == articleId,
    );
    if (index == -1) {
      return;
    }

    _savedArticles[index] = _savedArticles[index].copyWith(
      isRead: isRead,
      isSaved: isSaved,
      updatedAt: DateTime.now(),
    );
    invalidateFilterData();
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _savedArticlesSubscription?.cancel();
    super.dispose();
  }
}

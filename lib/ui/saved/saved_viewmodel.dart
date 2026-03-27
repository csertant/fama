import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../utils/utils.dart';

class SavedViewModel extends ChangeNotifier {
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
        .listen((articles) {
          _savedArticles = articles;
          notifyListeners();
        });

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  late final StreamSubscription<List<Article>> _savedArticlesSubscription;

  List<Article> _savedArticles = [];

  late Command0<void> load;
  late Command1<void, Article> markAsUnsaved;
  late Command1<void, Article> markAsRead;

  List<Article> get savedArticles => UnmodifiableListView(_savedArticles);

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(
          LocalDataNotFoundException('No active session found'),
        );
      }
      final savedArticlesResult = await _articleRepository.getSavedArticles(
        profileId: profileId,
      );
      switch (savedArticlesResult) {
        case Ok<List<Article>>():
          _savedArticles = savedArticlesResult.value;
          return const Result.ok(null);
        case Error<List<Article>>():
          return Result.error(savedArticlesResult.error);
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

  Future<Result<void>> _markAsUnsaved(Article article) async {
    final unsaveResult = await _articleRepository.markAsUnsaved(
      profileId: article.profileId,
      articleId: article.id,
    );
    switch (unsaveResult) {
      case Ok<void>():
        return const Result.ok(null);
      case Error<void>():
        return unsaveResult;
    }
  }

  Future<Result<void>> _markAsRead(Article article) async {
    final markAsReadResult = await _articleRepository.markAsRead(
      profileId: article.profileId,
      articleId: article.id,
    );
    switch (markAsReadResult) {
      case Ok<void>():
        return const Result.ok(null);
      case Error<void>():
        return markAsReadResult;
    }
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _savedArticlesSubscription.cancel();
    super.dispose();
  }
}

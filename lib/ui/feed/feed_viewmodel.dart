import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../utils/utils.dart';

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

  late Command0<void> load;
  late Command1<void, Article> markAsSaved;
  late Command1<void, Article> markAsRead;

  List<Article> get articles => UnmodifiableListView(_articles);

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(
          LocalDataNotFoundException('No active session found'),
        );
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
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  void _onSessionChanged() {
    unawaited(load.execute());
  }

  Future<Result<void>> _markAsSaved(Article article) async {
    try {
      final saveResult = await _articleRepository.markAsSaved(
        profileId: article.profileId,
        articleId: article.id,
      );
      switch (saveResult) {
        case Ok<void>():
          return const Result.ok(null);
        case Error<void>():
          return saveResult;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _markAsRead(Article article) async {
    try {
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
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    await _articlesSubscription.cancel();
    super.dispose();
  }
}

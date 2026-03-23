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
    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  List<Article> _articles = [];

  late Command0<void> load;
  late Command1<void, Article> markAsSaved;
  late Command1<void, Article> markAsRead;

  List<Article> get articles => UnmodifiableListView(_articles);

  Future<Result<void>> _load() async {
    try {
      //TODO: sessionManager!
      final syncResult = await _articleRepository.syncArticlesForProfile(
        profileId: 1,
      );
      switch (syncResult) {
        case Ok<void>():
          final articlesResult = await _articleRepository.getArticles(
            profileId: 1,
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

  Future<Result<void>> _markAsSaved(Article article) async {
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
}

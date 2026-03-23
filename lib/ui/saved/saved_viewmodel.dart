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
    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  List<Article> _savedArticles = [];

  late Command0<void> load;
  late Command1<void, Article> markAsUnsaved;
  late Command1<void, Article> markAsRead;

  List<Article> get savedArticles => UnmodifiableListView(_savedArticles);

  Future<Result<void>> _load() async {
    try {
      //TODO: sessionManager!
      final savedArticlesResult = await _articleRepository.getSavedArticles(
        profileId: 1,
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
}

import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../data/services/connectivity_service/connectivity_service.dart';
import '../../utils/utils.dart';
import '../core/mixins/article_filter_mixin.dart';
import '../core/widgets/widgets.dart';

class FeedViewModel extends ChangeNotifier with ArticleFilterMixin {
  FeedViewModel({
    required ArticleRepository articleRepository,
    required SessionManager sessionManager,
    required ConnectivityService connectivityService,
  }) : _sessionManager = sessionManager,
       _articleRepository = articleRepository,
       _connectivityService = connectivityService,
       _lastConnectionStatus = connectivityService.connectionStatus {
    load = Command0(_load);
    markAsSaved = Command1(_markAsSaved);
    markAsRead = Command1(_markAsRead);

    _sessionManager.addListener(_onSessionChanged);
    _connectivityService.addListener(_onConnectivityChanged);
    _articlesSubscription = _articleRepository
        .watchArticles(profileId: _sessionManager.profileId!)
        .listen(_onArticlesChanged);

    unawaited(load.execute());
  }

  final SessionManager _sessionManager;
  final ArticleRepository _articleRepository;
  StreamSubscription<List<Article>>? _articlesSubscription;
  final ConnectivityService _connectivityService;
  ConnectionStatus _lastConnectionStatus;

  List<Article> _articles = [];
  @override
  List<Article> get baseFilterArticles => _articles;

  int _selectedLimit = FilterLimit.defaultLimit;

  late Command0<void> load;
  late Command1<void, Article> markAsSaved;
  late Command1<void, Article> markAsRead;

  List<Article> get articles => UnmodifiableListView(_articles);

  @override
  List<Article> get filteredArticles {
    return super.filteredArticles.take(_selectedLimit).toList();
  }

  int get selectedLimit => _selectedLimit;

  Future<Result<void>> _load() async {
    try {
      final profileId = _sessionManager.profileId;
      if (profileId == null) {
        return Result.error(DataNotFoundException('No active session found'));
      }
      await _articleRepository.syncArticlesForProfile(profileId: profileId);
      final articlesResult = await _articleRepository.getArticles(
        profileId: profileId,
      );
      switch (articlesResult) {
        case Ok<List<Article>>():
          _articles = articlesResult.value;
          invalidateFilterData();
          return const Result.ok(null);
        case Error<List<Article>>():
          return Result.error(articlesResult.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> _onSessionChanged() async {
    await _articlesSubscription?.cancel();
    _articlesSubscription = _articleRepository
        .watchArticles(profileId: _sessionManager.profileId!)
        .listen(_onArticlesChanged);
    unawaited(load.execute());
  }

  void _onArticlesChanged(List<Article> articles) {
    _articles = articles;
    invalidateFilterData();
    notifyListeners();
  }

  void _onConnectivityChanged() {
    final currentStatus = _connectivityService.connectionStatus;
    if (_lastConnectionStatus == ConnectionStatus.offline &&
        currentStatus == ConnectionStatus.online) {
      unawaited(load.execute());
    }
    _lastConnectionStatus = currentStatus;
  }

  Future<Result<void>> _markAsSaved(Article article) async {
    try {
      final result = await _articleRepository.markAsSaved(
        profileId: article.profileId,
        articleId: article.id,
      );
      if (result is Ok<void>) {
        _updateLocalArticle(articleId: article.id, isSaved: true);
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
        _updateLocalArticle(articleId: article.id, isRead: true);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _updateLocalArticle({
    required Id articleId,
    bool? isRead,
    bool? isSaved,
  }) {
    final index = _articles.indexWhere((article) => article.id == articleId);
    if (index == -1) {
      return;
    }

    _articles[index] = _articles[index].copyWith(
      isRead: isRead,
      isSaved: isSaved,
      updatedAt: DateTime.now(),
    );
    invalidateFilterData();
  }

  void setLimit(int limit) {
    _selectedLimit = limit;
    notifyListeners();
  }

  @override
  void clearFilters() {
    super.clearFilters();
    _selectedLimit = FilterLimit.defaultLimit;
  }

  @override
  Future<void> dispose() async {
    _sessionManager.removeListener(_onSessionChanged);
    _connectivityService.removeListener(_onConnectivityChanged);
    await _articlesSubscription?.cancel();
    super.dispose();
  }
}

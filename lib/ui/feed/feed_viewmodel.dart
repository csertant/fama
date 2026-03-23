import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../utils/utils.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({required ArticleRepository articleRepository})
    : _articleRepository = articleRepository {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final ArticleRepository _articleRepository;
  List<Article> _articles = [];

  late Command0<void> load;

  List<Article> get articles => UnmodifiableListView(_articles);

  Future<Result<void>> _load() async {
    try {
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}

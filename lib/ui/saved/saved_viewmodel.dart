import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/repositories/article/article_repository.dart';
import '../../utils/command.dart';
import '../../utils/result.dart';

class SavedViewModel extends ChangeNotifier {
  SavedViewModel({required ArticleRepository articleRepository})
    : _articleRepository = articleRepository {
    load = Command0(_load);
    unawaited(load.execute());
  }

  final ArticleRepository _articleRepository;

  late Command0<void> load;

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

import 'package:flutter/material.dart';

import '../../data/repositories/article/article_repository.dart';

class SavedViewModel extends ChangeNotifier {
  SavedViewModel({required ArticleRepository articleRepository})
    : _articleRepository = articleRepository;

  final ArticleRepository _articleRepository;
}

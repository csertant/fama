import 'package:flutter/material.dart';

import '../../data/repositories/article/article_repository.dart';

class FeedViewModel extends ChangeNotifier {
  FeedViewModel({required ArticleRepository articleRepository})
    : _articleRepository = articleRepository;

  final ArticleRepository _articleRepository;
}

import '../../../utils/utils.dart';
import '../../database/database.dart';

abstract class ArticleRepository {
  Stream<List<Article>> watchArticles({required Id profileId});
  Stream<List<Article>> watchUnreadArticles({required Id profileId});

  Future<Result<void>> markAsRead({
    required final Id profileId,
    required final Id articleId,
  });

  Future<Result<void>> markAsUnread({
    required final Id profileId,
    required final Id articleId,
  });

  Future<Result<void>> markAsSaved({
    required final Id profileId,
    required final Id articleId,
  });

  Future<Result<void>> markAsUnsaved({
    required final Id profileId,
    required final Id articleId,
  });

  Future<Result<void>> syncArticlesForProfile({required Id profileId});
}

import 'exceptions.dart';
import 'result.dart';

Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Result.ok(result);
  } on Exception catch (e) {
    return Result.error(AppException.mapError(e));
  }
}

Future<Result<void>> guardVoid(Future<void> Function() action) async {
  try {
    await action();
    return const Result.ok(null);
  } on Exception catch (e) {
    return Result.error(AppException.mapError(e));
  }
}

Future<Result<T>> guardNotNull<T>(
  Future<T?> Function() action, {
  required AppException notFoundException,
}) async {
  try {
    final result = await action();
    if (result == null) {
      return Result.error(notFoundException);
    }
    return Result.ok(result);
  } on Exception catch (e) {
    return Result.error(AppException.mapError(e));
  }
}

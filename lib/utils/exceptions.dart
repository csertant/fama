class AppException implements Exception {
  AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';

  //TODO: map native exceptions to app exceptions
  static AppException mapError(Object error) {
    if (error is LocalDataException) {
      return error;
    }
    return LocalDataStorageException(
      'Failed to perform local data operation',
      cause: error,
    );
  }
}

class LocalDataException extends AppException {
  LocalDataException(super.message, {super.cause});

  @override
  String toString() => 'LocalDataException: $message';
}

class LocalDataNotFoundException extends LocalDataException {
  LocalDataNotFoundException(super.message);
}

class LocalDataStorageException extends LocalDataException {
  LocalDataStorageException(super.message, {super.cause});
}

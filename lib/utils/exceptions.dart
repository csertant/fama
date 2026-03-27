class AppException implements Exception {
  AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';

  //TODO: map native exceptions to app exceptions
  static AppException mapError(Object error) {
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

class RemoteDataException extends AppException {
  RemoteDataException(super.message, {super.cause});

  @override
  String toString() => 'RemoteDataException: $message';
}

class RemoteDataNotFoundException extends RemoteDataException {
  RemoteDataNotFoundException(super.message);
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.cause});

  @override
  String toString() => 'ValidationException: $message';
}

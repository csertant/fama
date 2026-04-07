import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class AppException implements Exception {
  AppException(this.message, {this.cause});

  factory AppException.fromError(Exception error) {
    if (error is AppException) {
      return error;
    } else if (error is StateError) {
      return DataStorageException('Row cardinality violated', cause: error);
    } else if (error is FormatException || error is InvalidDataException) {
      return DataStorageException('Data format is invalid', cause: error);
    } else if (error is DriftWrappedException) {
      return DataStorageException('Database operation failed', cause: error);
    } else if (error is TimeoutException) {
      return NetworkTimeoutException('Operation timed out', cause: error);
    } else if (error is ClientException) {
      return NetworkException('Network error occurred', cause: error);
    } else if (error is PlatformException) {
      return AppException('Platform-specific error occurred', cause: error);
    } else {
      return AppException('Unexpected error occurred', cause: error);
    }
  }

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.cause});

  @override
  String toString() => 'NetworkException: $message';
}

class NetworkNoInternetException extends NetworkException {
  NetworkNoInternetException(super.message, {super.cause});
}

class NetworkTimeoutException extends NetworkException {
  NetworkTimeoutException(super.message, {super.cause});
}

class DataException extends AppException {
  DataException(super.message, {super.cause});

  @override
  String toString() => 'DataException: $message';
}

class DataNotFoundException extends DataException {
  DataNotFoundException(super.message, {super.cause});
}

class DataStorageException extends DataException {
  DataStorageException(super.message, {super.cause});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.cause});

  @override
  String toString() => 'ValidationException: $message';
}

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class AppError implements Exception {
  AppError(this.message, {this.cause});

  factory AppError.fromError(Exception error) {
    if (error is AppError) {
      return error;
    } else if (error is StateError) {
      return DataStorageError('Row cardinality violated', cause: error);
    } else if (error is FormatException || error is InvalidDataException) {
      return DataStorageError('Data format invalid', cause: error);
    } else if (error is DriftWrappedException) {
      return DataStorageError('Database operation failed', cause: error);
    } else if (error is TimeoutException) {
      return NetworkTimeoutError('Operation timed out', cause: error);
    } else if (error is ClientException) {
      return NetworkError('Network error occurred', cause: error);
    } else if (error is PlatformException) {
      return AppError('Platform-specific error occurred', cause: error);
    } else {
      return AppError('Unexpected error occurred', cause: error);
    }
  }

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppError: $message';
}

class NetworkError extends AppError {
  NetworkError(super.message, {super.cause});

  @override
  String toString() => 'NetworkError: $message';
}

class NetworkNoInternetError extends NetworkError {
  NetworkNoInternetError(super.message, {super.cause});
}

class NetworkTimeoutError extends NetworkError {
  NetworkTimeoutError(super.message, {super.cause});
}

class DataError extends AppError {
  DataError(super.message, {super.cause});

  @override
  String toString() => 'DataError: $message';
}

class DataNotFoundError extends DataError {
  DataNotFoundError(super.message, {super.cause});
}

class DataStorageError extends DataError {
  DataStorageError(super.message, {super.cause});
}

class ValidationError extends AppError {
  ValidationError(super.message, {super.cause});

  @override
  String toString() => 'ValidationError: $message';
}

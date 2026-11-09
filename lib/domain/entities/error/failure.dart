abstract class Failure {
  final String? message;
  final StackTrace? stackTrace;
  final Exception? originalException;

  Failure({this.message, this.stackTrace, this.originalException});
}

// HTTP / Request errors
class BadRequestFailure extends Failure {
  BadRequestFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

class ServerFailure extends Failure {
  ServerFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

// Network
class NetworkFailure extends Failure {
  NetworkFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

// Database & Storage
class LocalDataBaseFailure extends Failure {
  LocalDataBaseFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

class RemoteDataBaseFailure extends Failure {
  RemoteDataBaseFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

class SearchFailure extends Failure {
  SearchFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

// Misc / Fallback
class UnmappedFailure extends Failure {
  UnmappedFailure({String? message, StackTrace? stackTrace, Exception? originalException})
    : super(message: message, stackTrace: stackTrace, originalException: originalException);
}

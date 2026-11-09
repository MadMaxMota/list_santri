import 'dart:io';
import 'package:dio/dio.dart';
import 'package:santri/domain/entities/error/failure.dart';

mixin HttpExceptionHandler {
  Failure handleError(Object e) {
    if (e is! DioException) return UnmappedFailure(message: e.toString());

    final DioException dex = e;
    final int? statusCode = dex.response?.statusCode;
    final String? serverMessage = _extractMessageFromResponse(dex);

    if (statusCode != null) {
      final Failure? byStatus = _handleErrorByStatusCode(
        statusCode,
        serverMessage,
      );
      if (byStatus != null) return byStatus;
    }

    return _handleErrorByType(dex, serverMessage);
  }

  Failure? _handleErrorByStatusCode(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return BadRequestFailure(message: message);
      case 401:
        return UnauthorizedFailure(message: message);
      case 404:
        return NotFoundFailure(message: message);
      case 500:
        return ServerFailure(message: message);
      case 503:
        return ServerFailure(message: message ?? 'Service Unavailable');
      case 429:
        return UnmappedFailure(message: message ?? 'Too Many Requests (429)');
      case 403:
        return UnmappedFailure(message: message ?? 'Forbidden (403)');
      default:
        return null;
    }
  }

  Failure _handleErrorByType(DioException e, String? serverMessage) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(message: serverMessage ?? e.message);

      case DioExceptionType.cancel:
        return UnmappedFailure(message: serverMessage ?? 'Request cancelled');

      case DioExceptionType.badResponse:
        final int? code = e.response?.statusCode;
        if (code != null && code >= 500 && code <= 599) {
          return ServerFailure(message: serverMessage ?? e.message);
        }
        return UnmappedFailure(message: serverMessage ?? e.message);

      case DioExceptionType.unknown:
        final Object? inner = e.error;
        if (inner is SocketException) {
          return NetworkFailure(message: serverMessage ?? inner.message);
        }
        final String innerStr = inner?.toString().toLowerCase() ?? '';
        if (innerStr.contains('network') || innerStr.contains('connection')) {
          return NetworkFailure(message: serverMessage ?? e.message);
        }
        return UnmappedFailure(message: serverMessage ?? e.message);

      default:
        return UnmappedFailure(message: serverMessage ?? e.message);
    }
  }

  String? _extractMessageFromResponse(DioException e) {
    final Response<dynamic>? resp = e.response;
    if (resp == null) return null;

    final data = resp.data;
    if (data is Map) {
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'] as String;
      }
      if (data['error'] is String && (data['error'] as String).isNotEmpty) {
        return data['error'] as String;
      }
      if (data['errors'] != null) {
        return data['errors'].toString();
      }
    }

    if (resp.statusMessage != null && resp.statusMessage!.isNotEmpty) {
      return resp.statusMessage;
    }

    return null;
  }
}

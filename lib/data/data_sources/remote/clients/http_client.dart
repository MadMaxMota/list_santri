import 'package:dio/dio.dart';
import 'package:santri/data/data_sources/remote/clients/http_exception_handler.dart';

class HttpClient with HttpExceptionHandler {
  final Dio _dio;

  HttpClient({required Dio dio}) : _dio = dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}

import 'package:dio/dio.dart';
import 'api_interceptor.dart';

/// Centralized Dio HTTP client for external API calls
/// (recommendation service, visualizer service, etc.).
///
/// Firebase SDK calls do NOT go through this — they use their own transport.
class DioClient {
  late final Dio dio;

  DioClient({String? baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor());
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.post(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return dio.put(path, data: data, options: options);
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return dio.delete(path, data: data, options: options);
  }

  /// Multipart upload (for visualizer service, etc.)
  Future<Response> uploadMultipart(
    String path, {
    required FormData formData,
    Options? options,
  }) async {
    return dio.post(path, data: formData, options: options);
  }
}

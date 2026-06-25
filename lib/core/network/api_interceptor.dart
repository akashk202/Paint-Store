import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Dio interceptor that:
/// 1. Attaches Firebase Auth ID token to requests (for external APIs)
/// 2. Logs requests and responses in debug mode
class ApiInterceptor extends Interceptor {
  final FirebaseAuth _auth;

  ApiInterceptor({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Attach Firebase auth token if user is logged in
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('ApiInterceptor: Failed to get auth token: $e');
      }
    }

    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
          '✖ ${err.type}: ${err.message} [${err.requestOptions.uri}]');
    }

    // Handle token expiration
    if (err.response?.statusCode == 401) {
      debugPrint('ApiInterceptor: Unauthorized — token may be expired');
    }

    handler.next(err);
  }
}

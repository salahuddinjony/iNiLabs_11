import 'package:dio/dio.dart';
import 'package:inilab/core/constants/api_constants.dart';

/// API Service for handling all HTTP requests
class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: ApiConstants.headers,
      ),
    );

    // Add interceptors for logging
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// POST request
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(
        path,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// GraphQL request
  Future<Response> graphql(String query) async {
    try {
      final response = await dio.post(
        '/graphql',
        data: {'query': query},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  //   // multipart POST request
  //   Future<Response> postMultipart(String path, FormData data) async {
  //     try {
  //       final response = await dio.post(
  //         path,
  //         data: data,
  //         options: Options(
  //           contentType: 'multipart/form-data',
  //         ),
  //       );
  //       return response;
  //     } on DioException catch (e) {
  //       throw handleError(e);
  //     }
  //   }
  //   /// PUT request
  //   Future<Response> put(String path, {Map<String, dynamic>? data}) async {
  //     try {
  //       final response = await dio.put(
  //         path,
  //         data: data,
  //       );
  //       return response;
  //     } on DioException catch (e) {
  //       throw handleError(e);
  //     }
  //   }
  //   /// DELETE request
  //   Future<Response> delete(String path) async {
  //     try {
  //       final response = await dio.delete(path);
  //       return response;
  //     } on DioException catch (e) {
  //       throw handleError(e);
  //     }
  //   }
  //   /// PATCH request
  //   Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
  //     try {
  //       final response = await dio.patch(
  //         path,
  //         data: data,
  //       );
  //       return response;
  //     } on DioException catch (e) {
  //       throw handleError(e);
  //     }
  //   }

  /// Handle Dio errors and return user-friendly messages
  String handleError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 401:
            errorMessage = 'Invalid GitHub token. Please update your token in settings.';
            break;
          case 404:
            errorMessage = 'User not found. Please check the username.';
            break;
          case 403:
            errorMessage = 'API rate limit exceeded. Please try again later.';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later.';
            break;
          default:
            errorMessage = 'Something went wrong. Please try again.';
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled.';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection. Please check your network.';
        break;
      default:
        errorMessage = 'Unexpected error occurred. Please try again.';
    }

    return errorMessage;
  }
}

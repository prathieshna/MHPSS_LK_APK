import 'package:beprepared/core/resources/all_imports.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio();
    dio.options.baseUrl = ""; //APIConstants.baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 50000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {
      'content-type': 'application/json',
      'x-hasura-admin-secret':
          't0GEA0YSQ1b4glWb34yQX1bUtKeVbzK8VEe9OJHHGfBMQKiXyeQHYij3RfMWODdB'
    };

    // Add interceptors
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) async {
    //       // Add the access token to every request
    //       String? accessToken = await _getAccessToken();
    //       if (accessToken != null) {
    //         print("accessToken: $accessToken");
    //         options.headers["Authorization"] = "Bearer $accessToken";
    //       }
    //       handler.next(options);
    //     },
    //     onError: (error, handler) async {
    //       if (error.response?.statusCode == 401) {
    //         // Token is expired, try to refresh it
    //         String? refreshToken = await _getRefreshToken();
    //         Utils.displayToast("User authenticated!");

    // if (refreshToken != null) {
    //   // Assume we have a function to refresh the token
    //   var newTokens = await _refreshToken(refreshToken);
    //   if (newTokens != null) {
    //     // Retry the failed request with the new token
    //     error.requestOptions.headers["Authorization"] =
    //         "Bearer ${newTokens['accessToken']}";
    //     final opts = Options(
    //       method: error.requestOptions.method,
    //       headers: error.requestOptions.headers,
    //     );
    //     try {
    //       final clonedRequest = await dio.request(
    //         error.requestOptions.path,
    //         options: opts,
    //         data: error.requestOptions.data,
    //         queryParameters: error.requestOptions.queryParameters,
    //       );
    //       return handler.resolve(clonedRequest);
    //     } on DioException catch (e) {
    //       return handler.reject(e);
    //     }
    //   }
    // }
    // If the token cannot be refreshed, redirect to login or handle accordingly
    //         _handleTokenExpired();
    //       }
    //       handler.next(error);
    //     },
    //   ),
    // );
  }

  Future<String?> _getAccessToken() async {
    // String? accessToken = storage.getAuthToken;
    return ""; //accessToken;
  }

  Future<String?> _getRefreshToken() async {
    // String? refreshToken = storage.getAuthToken;
    return ""; //refreshToken;
  }

  //   Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
  //     // Implement your token refresh logic here
  //     // Update your stored tokens
  //     // Return new tokens if successful
  //     late RefreshTokenResponse refreshTokenResponse;

  //     refreshTokenResponse =
  //         await MainRepository().getRefreshToken(refreshToken: refreshToken);
  //     log("accessTokenExpire else: $refreshTokenResponse");
  //     if (refreshTokenResponse.success == true) {
  //       SharedPreferencesManger().saveUserTokenAndRefreshToken(
  //         userAccessToken: refreshTokenResponse.refreshTokenBody!.token!,
  //         userAccessTokenTime:
  //             refreshTokenResponse.refreshTokenBody!.tokenExpiration.toString(),
  //         userRefreshToken: refreshTokenResponse.refreshTokenBody!.refreshToken!,
  //         userRefreshTokenTime: refreshTokenResponse
  //             .refreshTokenBody!.refreshTokenExpiration
  //             .toString(),
  //       );
  //       return {
  //         "accessToken": refreshTokenResponse.refreshTokenBody!.token!,
  //       };
  //     } else {
  //       return null;
  //     }
  // }

  void _handleTokenExpired() async {
    // Handle token expiration (e.g., redirect to login)
    // await storage.clearHiveAll();
    // Utils.displayToast(
    //   "Session expired!",
    // );
    navigator.navigateToFullScreenDialog(const LoginScreen(
        // isBack: false,
        ));
  }

  // Implement the HTTP methods (get, post, put, delete, patch) using the `dio` instance
  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      dynamic data}) async {
    log("Dio: get path: $path");
    log("Dio: get queryParameters: $queryParameters");
    log("Dio: get options: $options");

    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        data: data,
      );
      return response;
    } on DioException catch (dioError) {
      log("DioError: get path: $path");
      log("DioError: get queryParameters: $queryParameters");
      log("DioError: get options: $dioError");
      log("DioError: get dioError.error: ${dioError.error}");
      log("DioError: get dioError.message: ${dioError.message}");
      log("DioError: get dioError.response: ${dioError.response}");
      final errorHandler = ErrorHandler.handle(dioError);
      throw Exception(errorHandler.failure.message);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("Dio: post path: $path");
    log("Dio: post queryParameters: $queryParameters");
    log("Dio: post options: $options");
    log("Dio: post data: $data");
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (dioError) {
      log("DioError: post path: $path");
      log("DioError: post queryParameters: $queryParameters");
      log("DioError: post data: $data");
      log("DioError: post dioError: $dioError");
      log("DioError: post dioError.error: ${dioError.error}");
      log("DioError: post dioError.message: ${dioError.message}");
      log("DioError: post dioError.response: ${dioError.response}");
      final errorHandler = ErrorHandler.handle(dioError);
      throw Exception(errorHandler.failure.message);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("Dio: put path: $path");
    log("Dio: put queryParameters: $queryParameters");
    log("Dio: put options: $options");
    log("Dio: put data: $data");
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (dioError) {
      log("DioError: put path: $path");
      log("DioError: put queryParameters: $queryParameters");
      log("DioError: put options: $data");
      log("DioError: put dioError: $dioError");
      log("DioError: put dioError.error: ${dioError.error}");
      log("DioError: put dioError.message: ${dioError.message}");
      log("DioError: put dioError.response: ${dioError.response}");
      final errorHandler = ErrorHandler.handle(dioError);
      throw Exception(errorHandler.failure.message);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    log("Dio: delete path: $path");
    log("Dio: delete queryParameters: $queryParameters");
    log("Dio: delete options: $options");
    log("Dio: delete data: $data");
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (dioError) {
      log("DioError: delete path: $path");
      log("DioError: delete queryParameters: $queryParameters");
      log("DioError: delete options: $data");
      log("DioError: delete dioError: $dioError");
      log("DioError: delete dioError.error: ${dioError.error}");
      log("DioError: delete dioError.message: ${dioError.message}");
      log("DioError: delete dioError.response: ${dioError.response}");
      final errorHandler = ErrorHandler.handle(dioError);
      throw Exception(errorHandler.failure.message);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    log("Dio: patch path: $path");
    log("Dio: patch queryParameters: $queryParameters");
    log("Dio: patch options: $options");
    log("Dio: patch data: $data");
    try {
      final response = await dio.patch<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException catch (dioError) {
      log("DioError: patch path: $path");
      log("DioError: patch queryParameters: $queryParameters");
      log("DioError: patch options: $data");
      log("DioError: patch dioError: $dioError");
      log("DioError: patch dioError.error: ${dioError.error}");
      log("DioError: patch dioError.message: ${dioError.message}");
      log("DioError: patch dioError.response: ${dioError.response}");
      final errorHandler = ErrorHandler.handle(dioError);
      throw Exception(errorHandler.failure.message);
    }
  }
}

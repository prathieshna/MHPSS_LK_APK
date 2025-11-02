import 'package:beprepared/core/resources/all_imports.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 401:
                  UserErrorResponse userErrorResponse =
                      UserErrorResponse.fromJson(error.response?.data);
                  errorDescription = userErrorResponse.data != null
                      ? userErrorResponse
                      : userErrorResponse.message;
                  // errorDescription = userErrorResponse.message;
                  break;
                case 404:
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errorResponse.message ??
                      errorResponse.error ??
                      error.response!.statusCode;

                  break;
                case 403:
                  errorDescription = 'Something went wrong !';
                  break;
                case 500:
                case 503:
                  try {
                    ErrorResponse errorResponse =
                        ErrorResponse.fromJson(error.response!.data);
                    errorDescription = errorResponse.message ??
                        errorResponse.error ??
                        error.response!.statusCode;
                  } catch (e) {
                    errorDescription = 'Something went wrong!';
                  }
                  break;
                default:
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errorResponse.message ??
                      errorResponse.error ??
                      error.response!.statusCode;
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              // TODO:: Handle bad certificate case.
              break;
            case DioExceptionType.connectionError:
              // TODO:: Handle connection error case.
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException {
        errorDescription = 'Server error Something went wrong !';
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}

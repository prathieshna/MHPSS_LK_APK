import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    this.status,
    this.message,
    this.error,
    this.key,
  });

  String? status;
  String? message;
  String? error;
  String? key;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "key": key,
      };
}

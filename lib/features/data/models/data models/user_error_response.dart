class UserErrorResponse {
  UserErrorResponse({
    this.status,
    this.message,
    this.data,
    this.key,
  });

  UserErrorResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    key = json['key'];
  }
  String? status;
  String? message;
  Data? data;
  String? key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['key'] = key;
    return map;
  }
}

class Data {
  Data({
    this.email,
    this.phone,
    this.emailVerified,
    this.phoneVerified,
  });

  Data.fromJson(dynamic json) {
    email = json['email'];
    phone = json['phone'];
    emailVerified = json['email_verified'];
    phoneVerified = json['phone_verified'];
  }
  String? email;
  String? phone;
  String? emailVerified;
  String? phoneVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['phone'] = phone;
    map['email_verified'] = emailVerified;
    map['phone_verified'] = phoneVerified;
    return map;
  }
}

class LoginResponse {
  final String status;
  final String message;
  final LoginPayload? payload;
  final int statusCode;

  LoginResponse({
    required this.status,
    required this.message,
    this.payload,
    required this.statusCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: json['payload'] != null 
          ? LoginPayload.fromJson(json['payload']) 
          : null,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload?.toJson(),
      'statusCode': statusCode,
    };
  }

  bool get isSuccess => status == 'success' && statusCode == 200;
}

class LoginPayload {
  final String userToken;
  final List<int> loginDate;
  final String refreshToken;

  LoginPayload({
    required this.userToken,
    required this.loginDate,
    required this.refreshToken
  });

  factory LoginPayload.fromJson(Map<String, dynamic> json) {
    return LoginPayload(
      userToken: json['userToken'] ?? '',
      loginDate: json['loginDate'] != null 
          ? List<int>.from(json['loginDate']) 
          : [],
          refreshToken: json["refreshToken"]??""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userToken': userToken,
      'loginDate': loginDate,
      'refreshToken':refreshToken
    };
  }

  DateTime get loginDateTime {
    if (loginDate.length >= 3) {
      return DateTime(loginDate[0], loginDate[1], loginDate[2]);
    }
    return DateTime.now();
  }
}
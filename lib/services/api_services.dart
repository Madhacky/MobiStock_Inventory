import 'dart:developer';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:smartbecho/services/secure_storage_service.dart';
import 'package:smartbecho/services/shared_preferences_services.dart';

class ApiServices {
  final Dio _dio = Dio();

  // Constructor to setup interceptors
  ApiServices() {
    _setupInterceptors();
  }

  // Setup interceptors for automatic session management
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) async {
        // Always extract and save new JSESSIONID from response
        await extractAndSaveSession(response);
        handler.next(response);
      },
      onError: (error, handler) async {
        // If session expired, try to refresh and retry
        if (error.response?.statusCode == 401 || 
            error.response?.statusCode == 403 || 
            error.response?.statusCode == 404) {
          
          log("🔄 Possible session expiry (${error.response?.statusCode}), checking session...");
          
          // For now, just log the error. You might want to implement auto-refresh here
          log("❌ Session might be expired. User may need to re-login.");
        }
        handler.next(error);
      },
    ));
  }

  // Extract and save JSESSIONID from response
  Future<void> extractAndSaveSession(Response response) async {
    try {
      final setCookieList = response.headers['set-cookie'];
      if (setCookieList != null && setCookieList.isNotEmpty) {
        for (String cookie in setCookieList) {
          final jsessionIdMatch = RegExp(r'JSESSIONID=([^;]+)').firstMatch(cookie);
          if (jsessionIdMatch != null) {
            final newJSessionId = jsessionIdMatch.group(1)!;
            // Save to SecureStorage, not SharedPreferences
            await SecureStorageHelper.setJSessionId(newJSessionId);
            log("🔄 Updated JSESSIONID: ${newJSessionId.substring(0, 8)}...");
            break;
          }
        }
      }
    } catch (e) {
      log("❌ Error extracting session: $e");
    }
  }

  Future<Response?> requestGetForApi({
    required String url,
    Map<String, dynamic>? dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        headers: await getHeader(authToken),
        baseUrl: url,
        receiveTimeout: const Duration(minutes: 2),
        connectTimeout: const Duration(minutes: 2),
        validateStatus: (_) => true,
      );
      _dio.options = options;

      Response response = await _dio.get(
        url,
        queryParameters: dictParameter,
        options: Options(headers: await getHeader(authToken)),
      );
      
      print("Response_data: ${response.data}");
      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

  /// POST
  Future<Response?> requestPostForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      Response response = await _dio.post(
        url,
        data: dictParameter,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

//put
Future<Response?> requestPutForApi({
  required String url,
  required Map<String, dynamic> dictParameter,
  required bool authToken,
}) async {
  try {
    print("Url:  $url");
    print("DictParameter: $dictParameter");

    BaseOptions options = BaseOptions(
      receiveTimeout: const Duration(minutes: 1),
      connectTimeout: const Duration(minutes: 1),
      headers: await getHeader(authToken),
    );
    _dio.options = options;

    Response response = await _dio.put(
      url,
      data: dictParameter,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: await getHeader(authToken),
      ),
    );

    print("Response: $response");
    print("Response_headers: ${response.headers}");
    print("Response_real_url: ${response.realUri}");

    return response;
  } catch (error) {
    print("Exception_Main: $error");
    return null;
  }
}

  /// MULTIPART
 Future<Response?> requestMultipartApi({
  String? url,
  FormData? formData,
  getx.RxDouble? percent,
  required bool authToken,
}) async {
  try {
    log("Url: $url");
    log("formData fields: ${formData?.fields}");
    
    // Safe logging for files
    if (formData?.files.isNotEmpty == true) {
      log("formData files: ${formData?.files[0].value.filename}");
    }

    // Configure Dio options - don't set baseUrl, use empty string or remove it
    BaseOptions options = BaseOptions(
      receiveTimeout: const Duration(minutes: 1),
      connectTimeout: const Duration(minutes: 1),
      headers: await getHeader(authToken),
    );

    _dio.options = options;
    
    Response response = await _dio.post(
      url!, // Use the full URL here
      onSendProgress: percent != null ? (count, total) {
        percent.value = (count / total) * 100;
        print("Progress: ${percent.value}%");
      } : null, // Only set callback if percent is not null
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: await getHeader(authToken),
      ),
    );

    log("Response Status: ${response.statusCode}");
    log("Response: ${response.data}");
    return response;
  } catch (error) {
    log("Exception_Main: $error");
    log("Exception Type: ${error.runtimeType}");
    
    // More specific error handling
    if (error is DioException) {
      log("DioException Type: ${error.type}");
      log("DioException Message: ${error.message}");
      if (error.response != null) {
        log("Error Response Status: ${error.response?.statusCode}");
        log("Error Response Data: ${error.response?.data}");
      }
    }
    
    return null;
  }
}

  //patch method
  Future<Response?> requestPatchForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      Response response = await _dio.patch(
        url,
        data: dictParameter,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

  //patch method
  Future<Response?> requestDeleteForApi({
    required String url,
    required Map<String, dynamic> dictParameter,
    required bool authToken,
  }) async {
    try {
      print("Url:  $url");
      print("DictParameter: $dictParameter");

      BaseOptions options = BaseOptions(
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1),
        headers: await getHeader(authToken),
      );
      _dio.options = options;

      Response response = await _dio.delete(
        url,
        data: dictParameter,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: await getHeader(authToken),
        ),
      );

      print("Response: $response");
      print("Response_headers: ${response.headers}");
      print("Response_real_url: ${response.realUri}");

      return response;
    } catch (error) {
      print("Exception_Main: $error");
      return null;
    }
  }

  // Updated method - now automatically gets the latest JSESSIONID
  Future<Response?> requestGetWithJSessionId({
    required String url,
    Map<String, dynamic>? dictParameter,
    required bool authToken,
    String? jsessionId, // Made optional - will get from storage if not provided
  }) async {
    try {
      // Get the latest JSESSIONID from secure storage
      String? sessionId = jsessionId ?? await SecureStorageHelper.getJSessionId();
      
      if (sessionId == null) {
        log("❌ No JSESSIONID found in storage");
        return null;
      }

      final headers = await getHeaderWithJSessionId(
        jsessionId: sessionId,
        authToken: authToken,
      );

      log("🔍 Using JSESSIONID: ${sessionId.substring(0, 8)}...");

      BaseOptions options = BaseOptions(
        headers: headers,
        receiveTimeout: const Duration(minutes: 2),
        connectTimeout: const Duration(minutes: 2),
        validateStatus: (_) => true,
      );

      _dio.options = options;

      final response = await _dio.get(
        url,
        queryParameters: dictParameter,
        options: Options(headers: headers),
      );

      print("Response_data: ${response.data}");
      print("Response_status: ${response.statusCode}");
      
      return response;
    } catch (error) {
      print("Exception_JSESSIONID: $error");
      return null;
    }
  }

  // Updated to include Content-Type in session headers
  Future<Map<String, String>> getHeaderWithJSessionId({
    required String jsessionId,
    required bool authToken,
  }) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    if (authToken) {
      // Get JWT token from SharedPreferences
      String? jwtToken = await SharedPreferencesHelper.getJwtToken();
      log("header token = : $jwtToken");

      if (jwtToken != null && jwtToken.isNotEmpty) {
        headers["Cookie"] = "JSESSIONID=$jsessionId; jwtToken=$jwtToken";
        headers["Authorization"] = "Bearer $jwtToken";
      } else {
        headers["Cookie"] = "JSESSIONID=$jsessionId";
        log("⚠️ JWT token is null, using only JSESSIONID");
      }
    } else {
      headers["Cookie"] = "JSESSIONID=$jsessionId";
    }

    return headers;
  }

  Future<Map<String, String>> getHeader(bool authToken) async {
    if (authToken) {
      String? jwtToken = await SharedPreferencesHelper.getJwtToken();
      log("header token = : $jwtToken");

      return {
        "Content-type": "application/json",
        "Authorization": "Bearer $jwtToken",
      };
    } else {
      return {
        "Content-type": "application/json",
      };
    }
  }

  // Helper method to check if session is still valid
  Future<bool> isSessionValid() async {
    String? jsessionId = await SecureStorageHelper.getJSessionId();
    return jsessionId != null && jsessionId.isNotEmpty;
  }

  // Method to manually refresh session (call after login)
  Future<void> refreshSession() async {
    log("🔄 Session refresh requested");
    // This will be handled automatically by the interceptor
    // when the next request is made
  }
}
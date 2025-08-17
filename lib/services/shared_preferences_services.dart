import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _ssUserName = "ssUserName";
  static const String _jwtTokenKey = "jwtToken";
  static const String _loginDateKey = "loginDate";
  static const String _jsessionIdKey = 'jsession_id';
  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssUserName, username);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssUserName);
  }

  // JWT Token methods
  static Future<void> setJwtToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, token);
  }

  static Future<String?> getJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtTokenKey);
  }

  static Future<void> setJSessionId(String jsessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jsessionIdKey, jsessionId);
  }

  static Future<String?> getJSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jsessionIdKey);
  }

  // Login date methods
  static Future<void> setLoginDate(String loginDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginDateKey, loginDate);
  }

  static Future<List<int>?> getLoginDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginDateJson = prefs.getString(_loginDateKey);
    if (loginDateJson != null) {
      return List<int>.from(jsonDecode(loginDateJson));
    }
    return null;
  }

  // Shop ID methods
  static const String _shopIdKey = 'shop_id';

  static Future<void> setShopId(String shopId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopIdKey, shopId);
  }

  static Future<String?> getShopId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopIdKey);
  }

  static Future<void> removeShopId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shopIdKey);
  }

  // Store shop store name
  static const String _shopStoreNameKey = 'shop_store_name';

  static Future<void> setShopStoreName(String shopStoreName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopStoreNameKey, shopStoreName);
  }

  static Future<String?> getShopStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopStoreNameKey);
  }

  static Future<void> removeShopStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shopStoreNameKey);
  }

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

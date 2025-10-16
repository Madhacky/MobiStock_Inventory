import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _ssUserName = "ssUserName";
  static const String _jwtTokenKey = "jwtToken";
  static const String _loginDateKey = "loginDate";
  static const String _jsessionIdKey = 'jsession_id';
  static const String _shopIdKey = 'shop_id';
  static const String _shopStoreNameKey = 'shop_store_name';
  
  // New User Profile Keys
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'email';
  static const String _phoneKey = 'phone';
  static const String _profilePhotoUrlKey = 'profile_photo_url';
  static const String _gstNumberKey = 'gst_number';
  static const String _adhaarNumberKey = 'adhaar_number';
  static const String _creationDateKey = 'creation_date';
  static const String _userStatusKey = 'user_status';
  
  // Notification Preferences Keys
  static const String _notifyByEmailKey = 'notify_by_email';
  static const String _notifyBySMSKey = 'notify_by_sms';
  static const String _notifyByWhatsAppKey = 'notify_by_whatsapp';
  
  // Shop Address Keys
  static const String _shopAddressIdKey = 'shop_address_id';
  static const String _shopCityKey = 'shop_city';
  static const String _shopStateKey = 'shop_state';
  static const String _shopCountryKey = 'shop_country';
  static const String _shopPincodeKey = 'shop_pincode';
  static const String _shopAddressLabelKey = 'shop_address_label';

  // Existing methods
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

  // NEW USER PROFILE METHODS

  // User ID
  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Email
  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Phone
  static Future<void> setPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneKey, phone);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneKey);
  }

  // Profile Photo URL
  static Future<void> setProfilePhotoUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profilePhotoUrlKey, url);
  }

  static Future<String?> getProfilePhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profilePhotoUrlKey);
  }

  // GST Number
  static Future<void> setGstNumber(String gstNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gstNumberKey, gstNumber);
  }

  static Future<String?> getGstNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_gstNumberKey);
  }

  // Adhaar Number
  static Future<void> setAdhaarNumber(String adhaarNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adhaarNumberKey, adhaarNumber);
  }

  static Future<String?> getAdhaarNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adhaarNumberKey);
  }

  // Creation Date
  static Future<void> setCreationDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_creationDateKey, date);
  }

  static Future<String?> getCreationDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_creationDateKey);
  }

  // User Status
  static Future<void> setUserStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatusKey, status);
  }

  static Future<String?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userStatusKey);
  }

  // NOTIFICATION PREFERENCES

  static Future<void> setNotifyByEmail(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyByEmailKey, value);
  }

  static Future<bool> getNotifyByEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifyByEmailKey) ?? false;
  }

  static Future<void> setNotifyBySMS(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyBySMSKey, value);
  }

  static Future<bool> getNotifyBySMS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifyBySMSKey) ?? false;
  }

  static Future<void> setNotifyByWhatsApp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifyByWhatsAppKey, value);
  }

  static Future<bool> getNotifyByWhatsApp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notifyByWhatsAppKey) ?? false;
  }

  // SHOP ADDRESS METHODS

  static Future<void> setShopAddressId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopAddressIdKey, id);
  }

  static Future<String?> getShopAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopAddressIdKey);
  }

  static Future<void> setShopCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopCityKey, city);
  }

  static Future<String?> getShopCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopCityKey);
  }

  static Future<void> setShopState(String state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopStateKey, state);
  }

  static Future<String?> getShopState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopStateKey);
  }

  static Future<void> setShopCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopCountryKey, country);
  }

  static Future<String?> getShopCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopCountryKey);
  }

  static Future<void> setShopPincode(String pincode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopPincodeKey, pincode);
  }

  static Future<String?> getShopPincode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopPincodeKey);
  }

  static Future<void> setShopAddressLabel(String label) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopAddressLabelKey, label);
  }

  static Future<String?> getShopAddressLabel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopAddressLabelKey);
  }

  // Clear user profile data only (keep login state)
  static Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_profilePhotoUrlKey);
    await prefs.remove(_gstNumberKey);
    await prefs.remove(_adhaarNumberKey);
    await prefs.remove(_creationDateKey);
    await prefs.remove(_userStatusKey);
    await prefs.remove(_notifyByEmailKey);
    await prefs.remove(_notifyBySMSKey);
    await prefs.remove(_notifyByWhatsAppKey);
    await prefs.remove(_shopAddressIdKey);
    await prefs.remove(_shopCityKey);
    await prefs.remove(_shopStateKey);
    await prefs.remove(_shopCountryKey);
    await prefs.remove(_shopPincodeKey);
    await prefs.remove(_shopAddressLabelKey);
  }

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
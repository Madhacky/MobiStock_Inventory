import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/services/shared_preferences_services.dart';
import 'dart:convert';

class UserProfileService extends GetxService {
  static final String baseUrl = AppConfig.instance.baseUrl;
  
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;
  
  /// Fetch current user profile and save to SharedPreferences
  Future<bool> fetchAndSaveUserProfile() async {
    try {
      isLoading.value = true;
      
      // Get token from SharedPreferences
      final token = await SharedPreferencesHelper.getJwtToken();
      
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'Authentication token not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/users/current-user'),
        headers: {
          'accept': 'application/json, text/plain, */*',
          'authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'success' && data['payload'] != null) {
          final payload = data['payload'];
          userProfile.value = payload;
          
          // Save user data to SharedPreferences
          await SharedPreferencesHelper.setUserId(payload['id']?.toString() ?? '');
          await SharedPreferencesHelper.setShopId(payload['shopId'] ?? '');
          await SharedPreferencesHelper.setShopStoreName(payload['shopStoreName'] ?? '');
          await SharedPreferencesHelper.setEmail(payload['email'] ?? '');
          await SharedPreferencesHelper.setPhone(payload['phone'] ?? '');
          await SharedPreferencesHelper.setProfilePhotoUrl(payload['profilePhotoUrl'] ?? '');
          await SharedPreferencesHelper.setGstNumber(payload['gstnumber'] ?? '');
          await SharedPreferencesHelper.setAdhaarNumber(payload['adhaarNumber'] ?? '');
          await SharedPreferencesHelper.setCreationDate(payload['creationDate'] ?? '');
          await SharedPreferencesHelper.setUserStatus(payload['status']?.toString() ?? '1');
          
          // Save notification preferences
          await SharedPreferencesHelper.setNotifyByEmail(payload['notifyByEmail'] ?? false);
          await SharedPreferencesHelper.setNotifyBySMS(payload['notifyBySMS'] ?? false);
          await SharedPreferencesHelper.setNotifyByWhatsApp(payload['notifyByWhatsApp'] ?? false);
          
          // Save shop address if available
          if (payload['shopAddress'] != null) {
            final address = payload['shopAddress'];
            await SharedPreferencesHelper.setShopAddressId(address['id']?.toString() ?? '');
            await SharedPreferencesHelper.setShopCity(address['city'] ?? '');
            await SharedPreferencesHelper.setShopState(address['state'] ?? '');
            await SharedPreferencesHelper.setShopCountry(address['country'] ?? '');
            await SharedPreferencesHelper.setShopPincode(address['pincode'] ?? '');
            await SharedPreferencesHelper.setShopAddressLabel(address['label'] ?? '');
          }
          
          isLoading.value = false;
          return true;
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        await logout();
        return false;
      }
      
      Get.snackbar(
        'Error',
        'Failed to fetch user profile',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
  
  /// Get user profile data from SharedPreferences
  Future<Map<String, dynamic>> getUserProfileData() async {
    return {
      'userId': await SharedPreferencesHelper.getUserId(),
      'shopId': await SharedPreferencesHelper.getShopId(),
      'shopStoreName': await SharedPreferencesHelper.getShopStoreName(),
      'email': await SharedPreferencesHelper.getEmail(),
      'phone': await SharedPreferencesHelper.getPhone(),
      'profilePhotoUrl': await SharedPreferencesHelper.getProfilePhotoUrl(),
      'gstNumber': await SharedPreferencesHelper.getGstNumber(),
      'adhaarNumber': await SharedPreferencesHelper.getAdhaarNumber(),
      'creationDate': await SharedPreferencesHelper.getCreationDate(),
      'status': await SharedPreferencesHelper.getUserStatus(),
      'notifyByEmail': await SharedPreferencesHelper.getNotifyByEmail(),
      'notifyBySMS': await SharedPreferencesHelper.getNotifyBySMS(),
      'notifyByWhatsApp': await SharedPreferencesHelper.getNotifyByWhatsApp(),
      'shopAddress': {
        'id': await SharedPreferencesHelper.getShopAddressId(),
        'city': await SharedPreferencesHelper.getShopCity(),
        'state': await SharedPreferencesHelper.getShopState(),
        'country': await SharedPreferencesHelper.getShopCountry(),
        'pincode': await SharedPreferencesHelper.getShopPincode(),
        'label': await SharedPreferencesHelper.getShopAddressLabel(),
      }
    };
  }
  
  /// Logout and clear user data
  Future<void> logout() async {
    await SharedPreferencesHelper.clearAll();
    userProfile.clear();
    // Navigate to login screen
    // Get.offAllNamed('/login'); // Uncomment and adjust route as needed
  }
  
  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await SharedPreferencesHelper.getIsLoggedIn();
  }
  
  /// Get specific user info methods for convenience
  Future<String?> getShopName() async {
    return await SharedPreferencesHelper.getShopStoreName();
  }
  
  Future<String?> getUserEmail() async {
    return await SharedPreferencesHelper.getEmail();
  }
  
  Future<String?> getUserPhone() async {
    return await SharedPreferencesHelper.getPhone();
  }
}
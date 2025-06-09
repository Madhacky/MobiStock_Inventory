import 'package:mobistock/utils/shared_preferences_helpers.dart';

class ValidateUser {
    // Check if user is logged in 
 static Future<bool> checkLoginStatus() async {
    try {
      bool isLoggedIn = await SharedPreferencesHelper.getIsLoggedIn();
      String? token = await SharedPreferencesHelper.getJwtToken();

      // Check if both login status and token exist
      return isLoggedIn && token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }
}
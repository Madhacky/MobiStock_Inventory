import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable profile data
  var isEditing = false.obs;
  var shopName = 'Ramu Mobile Accessories'.obs;
  var shopId = 'SHOP001'.obs;
  var emailAddress = 'superAdmin@gmail.com'.obs;
  var shopAddress = 'Shop No. 123, Main Market'.obs;
  var shopLocation = 'Electronics Complex, Ground Floor'.obs;
  var nearLandmark = 'Near City Mall'.obs;
  var city = 'Bhopal, Madhya Pradesh'.obs;
  var accountStatus = 'Active'.obs;
  var memberSince = '24/02/2025'.obs;
  var passwordStatus = 'Updated'.obs;
  var userId = '#1'.obs;
  var pinCode = '462001'.obs;
  var phoneNumber = '+91 98765 43210'.obs;
  
  // Gallery images (placeholder for now)
  var galleryImages = <String>[].obs;
  
  // Toggle edit mode
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }
  
  // Save profile changes
  void saveProfile() {
    isEditing.value = false;
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Color(0xFF51CF66),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }
  
  // Cancel editing
  void cancelEdit() {
    isEditing.value = false;
    // Reset values to original (in real app, you'd revert to saved values)
  }
  
  // Upload gallery image
  void uploadImage() {
    // Simulate image upload
    Get.snackbar(
      'Info',
      'Image upload functionality would be implemented here',
      backgroundColor: Color(0xFF6C5CE7),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Change password
  void changePassword() {
    Get.snackbar(
      'Info',
      'Change password functionality would be implemented here',
      backgroundColor: Color(0xFFFF9500),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
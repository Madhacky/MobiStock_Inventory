import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/models/profile/user_profile_model.dart';
import 'dart:developer';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final ApiServices _apiService = ApiServices();

  // App config instance
  final AppConfig _config = AppConfig.instance;

  // Loading and error states
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Profile response data
  ProfileResponse? profileResponse;

  // Observable profile data
  var isEditing = false.obs;
  var shopName = ''.obs;
  var shopId = ''.obs;
  var emailAddress = ''.obs;
  var shopAddress = ''.obs;
  var shopLocation = ''.obs;
  var nearLandmark = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var pinCode = ''.obs;
  var phoneNumber = ''.obs;
  var accountStatus = ''.obs;
  var memberSince = ''.obs;
  var passwordStatus = ''.obs;
  var userId = ''.obs;
  var gstNumber = ''.obs;
  var adhaarNumber = ''.obs;
  var country = ''.obs;
  var facebookUrl = ''.obs;
  var instagramUrl = ''.obs;
  var websiteUrl = ''.obs;

  // Gallery images and social media
  var galleryImages = <ShopImage>[].obs;
  var socialMediaLinks = <SocialMediaLink>[].obs;

  // Computed properties
  String get fullAddress {
    final address = shopAddress.value;
    final landmark = nearLandmark.value;
    final cityState = '${city.value}, ${state.value}';
    final pin = pinCode.value;

    List<String> parts = [];
    if (address.isNotEmpty && address != 'N/A') parts.add(address);
    if (landmark.isNotEmpty && landmark != 'Near Landmark') parts.add(landmark);
    if (cityState.isNotEmpty && cityState != ', ') parts.add(cityState);
    if (pin.isNotEmpty && pin != '000000') parts.add(pin);

    return parts.join(', ');
  }

  String get formattedMemberSince {
    if (profileResponse?.payload.creationDate != null) {
      final date = profileResponse!.payload.creationDate!;
      if (date.length >= 3) {
        return '${date[2].toString().padLeft(2, '0')}/${date[1].toString().padLeft(2, '0')}/${date[0]}';
      }
    }
    return memberSince.value;
  }

  String get formattedPasswordUpdated {
    if (profileResponse?.payload.passwordUpdatedAt != null) {
      final date = profileResponse!.payload.passwordUpdatedAt!;
      if (date.length >= 3) {
        return '${date[2].toString().padLeft(2, '0')}/${date[1].toString().padLeft(2, '0')}/${date[0]}';
      }
    }
    return 'Not updated';
  }

  String get profileInitials {
    if (shopName.value.isNotEmpty) {
      List<String> words = shopName.value.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else {
        return words[0][0].toUpperCase();
      }
    }
    return 'U';
  }

  @override
  void onInit() {
    super.onInit();
    loadProfileFromApi();
  }

  // Load profile data from API
  Future<void> loadProfileFromApi() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.profile,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        profileResponse = ProfileResponse.fromJson(response.data);
        _updateProfileData(profileResponse!.payload);

        Get.snackbar(
          'Success',
          'Profile loaded successfully',
          backgroundColor: Color(0xFF51CF66),
          colorText: AppTheme.backgroundLight,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
      } else {
        hasError.value = true;
        errorMessage.value =
            'Failed to load profile. Status: ${response?.statusCode}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading profile: $e';
      log('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update observable variables with API data
  void _updateProfileData(UserProfile profile) {
    shopName.value = profile.shopStoreName;
    shopId.value = profile.shopId;
    emailAddress.value = profile.email;
    userId.value = '#${profile.id}';
    gstNumber.value = profile.gstnumber ?? '';
    adhaarNumber.value = profile.adhaarNumer ?? '';

    // Update address fields
    if (profile.shopAddress != null) {
      final address = profile.shopAddress!;
      shopAddress.value = '${address.addressLine1}, ${address.addressLine2}'
          .replaceAll('N/A, ', '')
          .replaceAll(', N/A', '');
      nearLandmark.value = address.landmark;
      city.value = address.city;
      state.value = address.state;
      pinCode.value = address.pincode;
      phoneNumber.value = address.phone;
      country.value = address.country;
    }

    // Update status and dates
    accountStatus.value = profile.status == 1 ? 'Active' : 'Inactive';
    memberSince.value = formattedMemberSince;
    passwordStatus.value =
        profile.passwordUpdatedAt != null ? 'Updated' : 'Not Updated';

    // Update gallery images
    galleryImages.assignAll(profile.images);

    // Update social media links
    socialMediaLinks.assignAll(profile.socialMediaLinks);
    facebookUrl.value = getSocialMediaLink('Facebook');
    instagramUrl.value = getSocialMediaLink('Instagram');
    websiteUrl.value = getSocialMediaLink('Website');
  }

  // Save profile changes to API
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      // Prepare update data according to your API body structure
      Map<String, dynamic> updateData = {
        'shopStoreName': shopName.value,
        'GSTNumber': gstNumber.value, // You'll need to add this field
        'adhaarNumer':
            adhaarNumber
                .value, // You'll need to add this field (note: typo in API - "adhaarNumer" instead of "adhaarNumber")
        'shopAddress': {
          'street': shopAddress.value,
          'city': city.value,
          'state': state.value,
          'zipCode': pinCode.value,
        },
        'socialMediaLinks': [
          if (facebookUrl.value.isNotEmpty)
            {'platform': 'Facebook', 'url': facebookUrl.value},
          if (instagramUrl.value.isNotEmpty)
            {'platform': 'Instagram', 'url': instagramUrl.value},
          if (websiteUrl.value.isNotEmpty)
            {'platform': 'Website', 'url': websiteUrl.value},
        ],
        'images': [
          // Add your image URLs here - you'll need to implement image handling
          if (galleryImages.isNotEmpty)
            ...galleryImages.map((url) => {'imageUrl': url.imageUrl}),
        ],
      };

      // Remove email field as it's not in your API body structure
      // Remove phone, country, landmark fields as they're not in your API structure

      dio.Response? response = await _apiService.requestPutForApi(
        url: _config.updateProfile,
        dictParameter: updateData,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        isEditing.value = false;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Color(0xFF51CF66),
          colorText: AppTheme.backgroundLight,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );

        // Reload profile data to get latest changes
        await loadProfileFromApi();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          backgroundColor: AppTheme.primaryRed,
          colorText: AppTheme.backgroundLight,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log('Error saving profile: $e');
      Get.snackbar(
        'Error',
        'Error updating profile: $e',
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    isEditing.value = !isEditing.value;
  }

  // Cancel editing
  void cancelEdit() {
    isEditing.value = false;
    // Reload original data
    if (profileResponse != null) {
      _updateProfileData(profileResponse!.payload);
    }
  }

  // Upload gallery image
  Future<void> addGalleryImage() async {
    try {
      // Placeholder for image upload logic
      Get.snackbar(
        'Info',
        'Image upload functionality would be implemented here',
        backgroundColor: Color(0xFF6C5CE7),
        colorText: AppTheme.backgroundLight,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error uploading image: $e',
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Remove gallery image
  void removeGalleryImage(int index) {
    if (index >= 0 && index < galleryImages.length) {
      galleryImages.removeAt(index);
      Get.snackbar(
        'Success',
        'Image removed successfully',
        backgroundColor: Color(0xFF51CF66),
        colorText: AppTheme.backgroundLight,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Open URL
  Future<void> openUrl(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open URL: $url',
          backgroundColor: AppTheme.primaryRed,
          colorText: AppTheme.backgroundLight,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  // Share profile
  void shareProfile() {
    Get.snackbar(
      'Info',
      'Share profile functionality would be implemented here',
      backgroundColor: Color(0xFFFF9500),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.TOP,
    );
    // Implement sharing logic (e.g., using share_plus package)
  }

  // Download profile
  void downloadProfile() {
    Get.snackbar(
      'Info',
      'Download profile functionality would be implemented here',
      backgroundColor: Color(0xFFFF9500),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.TOP,
    );
    // Implement download logic (e.g., generate PDF or export data)
  }

  // Show delete account dialog
  void showDeleteAccountDialog() {
    Get.defaultDialog(
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: AppTheme.backgroundLight,
      buttonColor: AppTheme.primaryRed,
      onConfirm: () {
        // Implement account deletion logic
        Get.snackbar(
          'Info',
          'Account deletion functionality would be implemented here',
          backgroundColor: AppTheme.primaryRed,
          colorText: AppTheme.backgroundLight,
          snackPosition: SnackPosition.TOP,
        );
        Get.back();
      },
    );
  }

  // Change password
  void changePassword() {
    Get.snackbar(
      'Info',
      'Change password functionality would be implemented here',
      backgroundColor: Color(0xFFFF9500),
      colorText: AppTheme.backgroundLight,
      snackPosition: SnackPosition.TOP,
    );
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await loadProfileFromApi();
  }

  // Get social media link by platform
  String getSocialMediaLink(String platform) {
    final link = socialMediaLinks.firstWhereOrNull(
      (link) => link.platform.toLowerCase() == platform.toLowerCase(),
    );
    return link?.url ?? '';
  }
}

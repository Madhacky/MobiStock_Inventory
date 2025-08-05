import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartbecho/models/auth/login_model.dart';
import 'package:smartbecho/models/auth/signup_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/services/cookie_extractor.dart';
import 'package:smartbecho/services/route_services.dart';
import 'package:smartbecho/services/secure_storage_service.dart';
import 'package:smartbecho/services/shared_preferences_services.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/toasts.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/views/auth/forgot_password_otp.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Separate GlobalKeys for each form
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  // Multi-step signup
  final RxInt currentStep = 1.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool subscribeToNewsletter = false.obs;

  // Basic Information Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopStoreNameController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController adhaarNumberController = TextEditingController();

  // Address Controllers
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  // Legacy controllers for backward compatibility
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();

  // Social Media Links
  final RxList<Map<String, dynamic>> socialMediaLinks = <Map<String, dynamic>>[].obs;

  // Shop Images
  final RxList<File?> shopImages = <File?>[].obs;
  final ImagePicker _picker = ImagePicker();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  // Animation Controller
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  // Track if controller is disposed
  bool _isDisposed = false;

  // API service instance
  final ApiServices _apiService = ApiServices();

  // App config instance
  final AppConfig _config = AppConfig.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeDefaultValues();
    _config.printConfig();
  }

  @override
  void onReady() {
    super.onReady();
    resetAnimations();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );
  }

  void _initializeDefaultValues() {
    // Set default country
    countryController.text = 'India';
    
    // Initialize with empty social media links
    socialMediaLinks.clear();
    
    // Initialize with empty shop images
    shopImages.clear();
  }

  void resetAnimations() {
    if (!_isDisposed &&
        (animationController.isCompleted || animationController.isDismissed)) {
      animationController.reset();
      animationController.forward();
    }
  }

  // Multi-step navigation methods
  void nextStep() {
    if (currentStep.value < 5) {
      if (_validateCurrentStep()) {
        currentStep.value++;
        resetAnimations();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      resetAnimations();
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        return signupFormKey.currentState?.validate() ?? false;
      case 2:
        return addressFormKey.currentState?.validate() ?? false;
      case 3:
        return true; // Social media links are optional
      case 4:
        return true; // Shop images are optional
      case 5:
        return agreeToTerms.value;
      default:
        return false;
    }
  }

  // Social Media Links Methods
  void addSocialMediaLink() {
    if (socialMediaLinks.length < 5) {
      socialMediaLinks.add({
        'platform': 'Facebook',
        'controller': TextEditingController(),
        'url': '',
      });
    }
  }

  void removeSocialMediaLink(Map<String, dynamic> link) {
    link['controller']?.dispose();
    socialMediaLinks.remove(link);
  }

  // Shop Images Methods
  Future<void> addShopImage() async {
    if (shopImages.length < 5) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        
        if (pickedFile != null) {
          shopImages.add(File(pickedFile.path));
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to pick image: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Limit Reached',
        'You can only add up to 5 images',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void removeShopImage(File? image) {
    shopImages.remove(image);
  }

  // Navigation methods
  void goToLogin() {
    Get.offNamed('/login')!.then((_) {
      if (Get.isRegistered<AuthController>() && !_isDisposed) {
        clearControllers();
      }
    });
  }

  void goToSignup() {
    Get.offNamed('/signup')!.then((_) {
      if (Get.isRegistered<AuthController>() && !_isDisposed) {
        clearControllers();
      }
    });
  }

  void goToResetPassword() {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        'Email is required',
        backgroundColor: AppTheme.errorDark,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } else {
      Get.toNamed('/reset-password');
    }
  }

  void clearControllers() {
    try {
      if (!_isDisposed) {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        nameController.clear();
        shopStoreNameController.clear();
        gstNumberController.clear();
        adhaarNumberController.clear();
        contactPersonController.clear();
        phoneNumberController.clear();
        addressLine1Controller.clear();
        addressLine2Controller.clear();
        landmarkController.clear();
        cityController.clear();
        stateController.clear();
        pincodeController.clear();
        countryController.clear();
        streetController.clear();
        zipcodeController.clear();
        
        // Clear social media links
        for (var link in socialMediaLinks) {
          link['controller']?.dispose();
        }
        socialMediaLinks.clear();
        
        // Clear shop images
        shopImages.clear();
        
        // Reset step and checkboxes
        currentStep.value = 1;
        agreeToTerms.value = false;
        subscribeToNewsletter.value = false;
      }
    } catch (e) {
      print('Controllers already disposed: $e');
    }
  }

  void clearAndNavigateToLogin() {
    clearControllers();
    Get.offNamed('/login');
  }

  void clearAndNavigateToSignup() {
    clearControllers();
    Get.offNamed('/signup');
  }

  // Toggle methods
  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain at least one uppercase letter';
    // }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateShopStoreName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Shop store name is required';
    }
    if (value.length < 2) {
      return 'Shop store name must be at least 2 characters';
    }
    return null;
  }

  String? validateGSTNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'GST number is required';
    }
    // GST number validation (15 characters)
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(value)) {
      return 'Please enter a valid GST number (e.g., 29ABCDE1234F1Z5)';
    }
    return null;
  }

  String? validateAdhaarNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar number is required';
    }
    // Aadhaar number validation (12 digits)
    if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
      return 'Please enter a valid 12-digit Aadhaar number';
    }
    return null;
  }

  String? validateContactPerson(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact person name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateAddressLine1(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address line 1 is required';
    }
    if (value.length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    if (value.length < 2) {
      return 'City must be at least 2 characters';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    if (value.length < 2) {
      return 'State must be at least 2 characters';
    }
    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Please enter a valid 6-digit pincode';
    }
    return null;
  }

  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Country is required';
    }
    if (value.length < 2) {
      return 'Country must be at least 2 characters';
    }
    return null;
  }

  // Legacy validation methods for backward compatibility
  String? validateStreet(String? value) {
    return validateAddressLine1(value);
  }

  String? validateZipcode(String? value) {
    return validatePincode(value);
  }

  // Auth methods
  // Login
  Future<void> login(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> loginParameters = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      };

      dio.Response? response = await _apiService.requestPostForApi(
        url: _config.loginEndpoint,
        dictParameter: loginParameters,
        authToken: false,
      );

      if (response != null) {
        try {
          await CookieExtractor.extractAndSaveJSessionId(response);
          LoginResponse loginResponse = LoginResponse.fromJson(response.data);

          if (loginResponse.isSuccess && loginResponse.payload != null) {
            String userToken = loginResponse.payload!.userToken;
            String refreshToken = loginResponse.payload!.refreshToken;
            List<int> loginDate = loginResponse.payload!.loginDate;

            await SharedPreferencesHelper.setJwtToken(userToken);
            await SharedPreferencesHelper.setLoginDate(loginDate);
            await SharedPreferencesHelper.setIsLoggedIn(true);

            if (loginParameters.containsKey('email')) {
              await SharedPreferencesHelper.setUsername(
                loginParameters['email'],
              );
            }

            RouteService.toDashboard();
            ToastCustom.successToast(context, 'Login Successful');
          } else {
            ToastCustom.errorToast(
              context,
              'Error: Please check email and password',
            );
          }
        } catch (parseError) {
          ToastCustom.errorToast(context, 'Invalid response format');
          print('Parse error: $parseError');
        }
      } else {
        ToastCustom.errorToast(
          context,
          'Network error. Please check your connection.',
        );
      }
    } catch (e) {
      ToastCustom.errorToast(context, 'Error Occurred: Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await SharedPreferencesHelper.clearAll();
      await SecureStorageHelper.deleteJSessionId();
      RouteService.logout();

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
// Signup - Fixed version with proper multipart file handling
Future<void> signup(BuildContext context) async {
  if (!agreeToTerms.value) {
    ToastCustom.errorToast(context, 'Please agree to terms and conditions');
    return;
  }

  try {
    isLoading.value = true;

    var formData = dio.FormData();

    // Basic Information
    formData.fields.add(MapEntry('shopStoreName', shopStoreNameController.text.trim()));
    formData.fields.add(MapEntry('email', emailController.text.trim()));
    formData.fields.add(MapEntry('password', passwordController.text.trim()));
    formData.fields.add(MapEntry('Status', '1'));
    formData.fields.add(MapEntry('role.id', '1'));

    // Address Information
    formData.fields.add(MapEntry('shopAddress.label', 'Shop'));
    formData.fields.add(MapEntry('shopAddress.city', cityController.text.trim()));
    formData.fields.add(MapEntry('shopAddress.state', stateController.text.trim()));
    formData.fields.add(MapEntry('shopAddress.pincode', pincodeController.text.trim()));
    formData.fields.add(MapEntry('shopAddress.country', countryController.text.trim()));

    // Additional fields
    formData.fields.add(MapEntry('GSTNumber', gstNumberController.text.trim()));
    formData.fields.add(MapEntry('AdhaarNumber', adhaarNumberController.text.trim()));

    // Optional fields
    if (contactPersonController.text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('contactPerson', contactPersonController.text.trim()));
    }
    if (phoneNumberController.text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('phoneNumber', phoneNumberController.text.trim()));
    }
    if (addressLine1Controller.text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('shopAddress.addressLine1', addressLine1Controller.text.trim()));
    }
    if (addressLine2Controller.text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('shopAddress.addressLine2', addressLine2Controller.text.trim()));
    }
    if (landmarkController.text.trim().isNotEmpty) {
      formData.fields.add(MapEntry('shopAddress.landmark', landmarkController.text.trim()));
    }

    // Social Media Links
    for (int i = 0; i < socialMediaLinks.length; i++) {
      var link = socialMediaLinks[i];
      String url = link['controller']?.text?.trim() ?? '';
      if (url.isNotEmpty) {
        formData.fields.add(MapEntry('socialMedia[$i].platform', link['platform']));
        formData.fields.add(MapEntry('socialMedia[$i].url', url));
      }
    }

    if (shopImages.isNotEmpty) {
      for (int i = 0; i < shopImages.length; i++) {
        File? imageFile = shopImages[i];
        if (imageFile != null && await imageFile.exists()) {
          try {
            // Get file extension
            String extension = imageFile.path.split('.').last.toLowerCase();
            String fileName = 'shop_image_${i + 1}.$extension';
            
            // Create multipart file with proper content type
            String contentType = 'image/jpeg';
            if (extension == 'png') contentType = 'image/png';
            
            formData.files.add(MapEntry(
              'file', // This should match your backend parameter name
              await dio.MultipartFile.fromFile(
                imageFile.path,
                filename: fileName,
                contentType: dio.DioMediaType.parse(contentType),
              ),
            ));
            
            print('Added image file: $fileName, size: ${await imageFile.length()} bytes');
          } catch (fileError) {
            print('Error processing image file ${i + 1}: $fileError');
            // Continue with other images even if one fails
          }
        }
      }
    }

    // Newsletter subscription
    if (subscribeToNewsletter.value) {
      formData.fields.add(MapEntry('subscribeToNewsletter', 'true'));
    }

    // Debug: Print FormData contents
    print('FormData fields count: ${formData.fields.length}');
    print('FormData files count: ${formData.files.length}');
    
    for (var field in formData.fields) {
      print('Field: ${field.key} = ${field.value}');
    }
    
    for (var file in formData.files) {
      print('File: ${file.key} = ${file.value.filename}');
    }

    dio.Response? response = await _apiService.requestMultipartApi(
      url: _config.signupEndpoint,
      formData: formData,
      authToken: false,
    );

    if (response != null && response.statusCode == 200) {
      try {
        SignupResponse signupResponse = SignupResponse.fromJson(response.data);

        if (response.statusCode == 200) {
          if (signupResponse.payload?.email != null) {
            await SharedPreferencesHelper.setUsername(
              signupResponse.payload!.email!,
            );
          }

          if (signupResponse.payload?.shopId != null) {
            await SharedPreferencesHelper.setShopId(
              signupResponse.payload!.shopId!,
            );
          }

          String successMessage = 'Account created successfully!';
          ToastCustom.successToast(context, successMessage);

          clearControllers();
          RouteService.backToLogin();
        } else {
          ToastCustom.errorToast(
            context,
            "Signup failed or account already exists",
          );
        }
      } catch (parseError) {
        ToastCustom.errorToast(context, 'Invalid response format');
        print('Parse error: $parseError');
        print('Response data: ${response.data}');
      }
    } else {
      if (response != null && response.statusCode == 400) {
        ToastCustom.errorToast(
          context,
          "Signup failed or account already exists",
        );
      } else if (response != null && response.statusCode == 500) {
        ToastCustom.errorToast(
          context,
          "Server error. Please try again later.",
        );
      } else {
        ToastCustom.errorToast(
          context,
          'Network error. Please check your connection.',
        );
      }
    }
  } catch (e) {
    ToastCustom.errorToast(context, 'Signup failed: ${e.toString()}');
    print('Signup error: $e');
  } finally {
    isLoading.value = false;
  }
}

  // Reset password
  Future<void> resetPassword(BuildContext context, String email) async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      bool isSuccess = await resetPasswordApi(email: email);
      if (isSuccess) {
        Get.snackbar(
          "Success",
          "Please check email for OTP",
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(AppRoutes.forgotPasswordOtp, parameters: {"email": email});
      } else {
        Get.snackbar(
          'Error',
          'Please try again later',
          backgroundColor: Colors.red.withValues(alpha:0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Reset failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password API
  Future<bool> resetPasswordApi({required String email}) async {
    try {
      dio.Response? response = await _apiService.requestPostForApi(
        url: _config.resetPasswordUrl,
        authToken: false,
        dictParameter: {'email': email},
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data = response.data is String
              ? json.decode(response.data)
              : response.data;

          if (data is Map<String, dynamic>) {
            String status = data['status'] ?? '';
            int statusCode = data['statusCode'] ?? 0;
            String message = data['message'] ?? '';

            if (status.toLowerCase() == 'success' && statusCode == 200) {
              log("✅ Reset password email sent successfully");
              log("Message: $message");
              return true;
            } else {
              log("❌ Reset password failed: $message");
              return false;
            }
          } else {
            log("❌ Unexpected response format in resetPasswordApi");
            return false;
          }
        } else {
          log("❌ Reset password API failed with status code: ${response.statusCode}");
          return false;
        }
      } else {
        log("❌ No response received from reset password API");
        return false;
      }
    } catch (error) {
      log("❌ Error in resetPasswordApi: $error");
      return false;
    }
  }

  @override
  void onClose() {
    _isDisposed = true;

    try {
      animationController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      nameController.dispose();
      shopStoreNameController.dispose();
      gstNumberController.dispose();
      adhaarNumberController.dispose();
      contactPersonController.dispose();
      phoneNumberController.dispose();
      addressLine1Controller.dispose();
      addressLine2Controller.dispose();
      landmarkController.dispose();
      cityController.dispose();
      stateController.dispose();
      pincodeController.dispose();
      countryController.dispose();
      streetController.dispose();
      zipcodeController.dispose();
      
      // Dispose social media controllers
      for (var link in socialMediaLinks) {
        link['controller']?.dispose();
      }
    } catch (e) {
      print('Error disposing controllers: $e');
    }

    super.onClose();
  }
}
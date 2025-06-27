import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/auth/login_model.dart';
import 'package:smartbecho/models/auth/signup_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/services/cookie_extractor.dart';
import 'package:smartbecho/services/route_services.dart' hide AppRoutes;
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
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopStoreNameController = TextEditingController();

  // Address Controllers
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();

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

  void resetAnimations() {
    if (!_isDisposed &&
        (animationController.isCompleted || animationController.isDismissed)) {
      animationController.reset();
      animationController.forward();
    }
  }

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
        streetController.clear();
        cityController.clear();
        stateController.clear();
        zipcodeController.clear();
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
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
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

  // Address validation methods
  String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Street address is required';
    }
    if (value.length < 5) {
      return 'Street address must be at least 5 characters';
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

  String? validateZipcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zipcode is required';
    }
    if (value.length < 5) {
      return 'Zipcode must be at least 5 characters';
    }
    // Optional: Add regex validation for zipcode format
    if (!RegExp(r'^\d{5,6}$').hasMatch(value)) {
      return 'Please enter a valid zipcode';
    }
    return null;
  }

  // Auth methods
  //login
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
        // After successful login
        try {
          // After successful login
          await CookieExtractor.extractAndSaveJSessionId(response);
          LoginResponse loginResponse = LoginResponse.fromJson(response.data);

          if (loginResponse.isSuccess && loginResponse.payload != null) {
            //meanwhile using refresh token
            String userToken = loginResponse.payload!.userToken;
            String refreshToken = loginResponse.payload!.refreshToken;
            List<int> loginDate = loginResponse.payload!.loginDate;

            await SharedPreferencesHelper.setJwtToken(refreshToken);
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
      // Clear all stored data
      await SharedPreferencesHelper.clearAll();
      await SecureStorageHelper.deleteJSessionId();
      // Navigate back to login screen
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

  //sign up - Updated to match the JSON payload structure with status check
  Future<void> signup(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> signupParameters = {
        'shopStoreName': shopStoreNameController.text.trim(),
        'shopAddress': {
          'street': streetController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'zipcode': zipcodeController.text.trim(),
        },
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
        'role': {'id': 1},
        'Status': 1,
      };

      dio.Response? response = await _apiService.requestPostForApi(
        url: _config.signupEndpoint,
        dictParameter: signupParameters,
        authToken: false,
      );

      if (response != null && response.statusCode == 200) {
        try {
          SignupResponse signupResponse = SignupResponse.fromJson(
            response.data,
          );

          // Check if signup was successful using status = 1 or isSuccess = true
          if (response.statusCode == 200) {
            // Store user information
            if (signupResponse.payload?.email != null) {
              await SharedPreferencesHelper.setUsername(
                signupResponse.payload!.email!,
              );
            }

            // Store shop information
            if (signupResponse.payload?.shopId != null) {
              await SharedPreferencesHelper.setShopId(
                signupResponse.payload!.shopId!,
              );
            }

            // Show success message from API or default message
            String successMessage = 'Account created successfully!';
            ToastCustom.successToast(context, successMessage);

            // Clear the form after successful signup
            clearControllers();

            // Navigate back to login
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

//reset pass
  Future<void> resetPassword(BuildContext context, String email) async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      bool isSuccess = await resetPasswordApi(email: email);
      if (isSuccess) {
        Get.snackbar(
          "Success",
          "Please check email for OTP",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        Get.toNamed(AppRoutes.forgotPasswordOtp, parameters: {"email": email});
      } else {
        Get.snackbar(
          'Error',
          'Please try again later',
          backgroundColor: Colors.red.withOpacity(0.8),
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

  //reset pass api
  Future<bool> resetPasswordApi({required String email}) async {
    try {
      dio.Response? response = await _apiService.requestPostForApi(
        url: _config.resetPasswordUrl,
        authToken: false,
        dictParameter: {'email': email},
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          // Check if the response indicates success
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
          log(
            "❌ Reset password API failed with status code: ${response.statusCode}",
          );
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

    // Safely dispose controllers
    try {
      animationController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      nameController.dispose();
      shopStoreNameController.dispose();
      streetController.dispose();
      cityController.dispose();
      stateController.dispose();
      zipcodeController.dispose();
    } catch (e) {
      print('Error disposing controllers: $e');
    }

    super.onClose();
  }
}

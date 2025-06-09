import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/models/auth/login_model.dart';
import 'package:mobistock/models/auth/signup_model.dart';
import 'package:mobistock/services/api_services.dart';
import 'package:mobistock/services/app_config.dart';
import 'package:mobistock/services/route_services.dart';
import 'package:mobistock/utils/shared_preferences_helpers.dart';
import 'package:mobistock/utils/toasts.dart';
import 'package:dio/dio.dart' as dio;

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
    Get.toNamed('/reset-password');
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
        try {
          LoginResponse loginResponse = LoginResponse.fromJson(response.data);

          if (loginResponse.isSuccess && loginResponse.payload != null) {
            String userToken = loginResponse.payload!.userToken;
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
      // Clear all stored data
      await SharedPreferencesHelper.clearAll();
      
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
        if (response != null &&response.statusCode == 400) {
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

  Future<void> resetPassword(BuildContext context) async {
    if (!resetPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      ToastCustom.successToast(context, "Password reset email sent!");
    } catch (e) {
      Get.snackbar('Error', 'Reset failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
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

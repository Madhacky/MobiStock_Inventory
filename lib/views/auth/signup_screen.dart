import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 40),
                      _buildSignupForm(controller),
                      const SizedBox(height: 32),
                      _buildSignupButton(controller, context),
                      const SizedBox(height: 40),
                      _buildLoginPrompt(controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.store_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your shop and get started',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSignupForm(AuthController controller) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // Shop Store Name
          _buildModernTextField(
            controller: controller.shopStoreNameController,
            hintText: 'Shop Store Name',
            prefixIcon: Icons.store_mall_directory_outlined,
            validator: controller.validateShopStoreName,
          ),
          const SizedBox(height: 20),
          
          // Email
          _buildModernTextField(
            controller: controller.emailController,
            hintText: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 20),
          
          // Password
          Obx(() => _buildModernTextField(
            controller: controller.passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: controller.obscurePassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value 
                  ? Icons.visibility_off_rounded 
                  : Icons.visibility_rounded,
                color: Colors.white.withOpacity(0.7),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: controller.validatePassword,
          )),
          const SizedBox(height: 20),
          
          // Confirm Password
          Obx(() => _buildModernTextField(
            controller: controller.confirmPasswordController,
            hintText: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            obscureText: controller.obscureConfirmPassword.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscureConfirmPassword.value 
                  ? Icons.visibility_off_rounded 
                  : Icons.visibility_rounded,
                color: Colors.white.withOpacity(0.7),
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            validator: controller.validateConfirmPassword,
          )),
          const SizedBox(height: 20),
          
          // Address Section Header
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Shop Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Street Address
          _buildModernTextField(
            controller: controller.streetController,
            hintText: 'Street Address',
            prefixIcon: Icons.home_outlined,
            validator: controller.validateStreet,
          ),
          const SizedBox(height: 20),
          
          // City and State Row
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: controller.cityController,
                  hintText: 'City',
                  prefixIcon: Icons.location_city_outlined,
                  validator: controller.validateCity,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: controller.stateController,
                  hintText: 'State',
                  prefixIcon: Icons.map_outlined,
                  validator: controller.validateState,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Zipcode
          _buildModernTextField(
            controller: controller.zipcodeController,
            hintText: 'Zipcode',
            prefixIcon: Icons.local_post_office_outlined,
            keyboardType: TextInputType.number,
            validator: controller.validateZipcode,
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white.withOpacity(0.7),
            size: 22,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
  
  Widget _buildSignupButton(AuthController controller, BuildContext context) {
    return Obx(() => Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFF8E8E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B6B).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: controller.isLoading.value ? null : () => controller.signup(context),
          child: Center(
            child: controller.isLoading.value 
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
          ),
        ),
      ),
    ));
  }
  
  Widget _buildLoginPrompt(AuthController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          onPressed: controller.goToLogin,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
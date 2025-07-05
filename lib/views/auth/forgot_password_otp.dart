import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/auth%20controllers/otp_controller.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller and set email
    final OTPController controller = Get.find();
    controller.setEmail(Get.parameters['email']!);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              buildCustomAppBar("Reset Password", isdark: false),
              Expanded(
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
                            _buildHeaderSection(),
                            const SizedBox(height: 10),
                            _buildOTPInputSection(controller),
                            const SizedBox(height: 20),
                            _buildPasswordSection(controller),
                            const SizedBox(height: 15),
                            _buildVerifyButton(controller),
                            const SizedBox(height: 22),
                            _buildResendSection(controller),
                            const SizedBox(height: 14),
                            _buildHelpHint(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.backgroundLight.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.lock_reset_outlined,
            size: 40,
            color: AppTheme.backgroundLight,
          ),
        ),

        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppStyles.custom(
                size: 16,
                color: AppTheme.backgroundLight.withOpacity(0.8),
                weight: FontWeight.w400,
                // height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Enter the OTP sent to '),
                TextSpan(
                  text: Get.parameters['email'],
                  style: AppStyles.custom(
                    weight: FontWeight.w600,
                    color: AppTheme.backgroundLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPInputSection(OTPController controller) {
    return Column(
      children: [
        Text(
          'Enter Verification Code',
          style: AppStyles.custom(
            size: 18,
            weight: FontWeight.w600,
            color: AppTheme.backgroundLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) => _buildOTPBox(controller, index),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPBox(OTPController controller, int index) {
    return Obx(
      () => Container(
        width: 45,
        height: 55,
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                controller.otpFocusIndex.value == index
                    ? AppTheme.backgroundLight
                    : controller.otpControllers[index].text.isNotEmpty
                    ? const Color(0xFF4CAF50).withOpacity(0.8)
                    : AppTheme.backgroundLight.withOpacity(0.3),
            width: controller.otpFocusIndex.value == index ? 2 : 1.5,
          ),
          boxShadow:
              controller.otpFocusIndex.value == index
                  ? [
                    BoxShadow(
                      color: AppTheme.backgroundLight.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: TextFormField(
          controller: controller.otpControllers[index],
          focusNode: controller.otpFocusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: AppStyles.custom(
            size: 24,
            weight: FontWeight.bold,
            color: AppTheme.backgroundLight,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => controller.onOTPChanged(value, index),
          onTap: () => controller.onOTPFieldTap(index),
        ),
      ),
    );
  }

  Widget _buildPasswordSection(OTPController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Password',
          style: AppStyles.custom(
            size: 18,
            weight: FontWeight.w600,
            color: AppTheme.backgroundLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildPasswordField(
          controller: controller.newPasswordController,
          hintText: 'Enter new password',
          obscureText: controller.isNewPasswordObscure,
          onToggleVisibility: controller.toggleNewPasswordVisibility,
        ),
        const SizedBox(height: 20),
        Text(
          'Confirm Password',
          style: AppStyles.custom(
            size: 18,
            weight: FontWeight.w600,
            color: AppTheme.backgroundLight,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        _buildPasswordField(
          controller: controller.confirmPasswordController,
          hintText: 'Confirm new password',
          obscureText: controller.isConfirmPasswordObscure,
          onToggleVisibility: controller.toggleConfirmPasswordVisibility,
        ),
        const SizedBox(height: 8),
        Obx(
          () =>
              controller.passwordError.value.isNotEmpty
                  ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryRed.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppTheme.primaryRed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.passwordError.value,
                            style: AppStyles.custom(
                              color: AppTheme.primaryRed,
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required RxBool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.backgroundLight.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText.value,
          style: AppStyles.custom(
            color: AppTheme.backgroundLight,
            size: 16,
            weight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.custom(
              color: AppTheme.backgroundLight.withOpacity(0.6),
              size: 16,
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppTheme.backgroundLight.withOpacity(0.7),
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText.value ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.backgroundLight.withOpacity(0.7),
                size: 20,
              ),
              onPressed: onToggleVisibility,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(OTPController controller) {
    return Obx(
      () => Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                controller.isFormValid.value
                    ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                    : [const Color(0xFFBDBDBD), const Color(0xFF9E9E9E)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              controller.isFormValid.value
                  ? [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : null,
        ),
        child: Material(
          color: AppTheme.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                controller.isLoading.value || !controller.isFormValid.value
                    ? null
                    : () => controller.verifyOTPresetPassword(),
            child: Center(
              child:
                  controller.isLoading.value
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.backgroundLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Resetting Password...',
                            style: AppStyles.custom(
                              color: AppTheme.backgroundLight,
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppTheme.backgroundLight,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Reset Password',
                            style: AppStyles.custom(
                              color: AppTheme.backgroundLight,
                              size: 18,
                              weight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection(OTPController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.backgroundLight.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Didn\'t receive the code?',
              style: AppStyles.custom(
                color: AppTheme.backgroundLight.withOpacity(0.8),
                size: 14,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            controller.canResendOTP.value
                ? GestureDetector(
                  onTap: () => controller.resendOTP(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF6B6B).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Resend Code',
                      style: AppStyles.custom(
                        color: Color(0xFFFF6B6B),
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                : Text(
                  'Resend in ${controller.resendTimer.value}s',
                  style: AppStyles.custom(
                    color: AppTheme.backgroundLight.withOpacity(0.6),
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundLight.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppTheme.backgroundLight.withOpacity(0.8),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Password must be at least 8 characters long with letters and numbers.',
              style: AppStyles.custom(
                color: AppTheme.backgroundLight.withOpacity(0.8),
                size: 13,
                weight: FontWeight.w400,
                // height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

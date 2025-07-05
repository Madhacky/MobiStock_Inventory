import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/services/route_services.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_appbar.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String email = Get.parameters['email'] ?? '';
    log(email);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              buildCustomAppBar("Verify E-mail", isdark: false),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderSection(email),
                        const SizedBox(height: 40),
                        _buildActionButtons(),
                      ],
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

  Widget _buildHeaderSection(String email) {
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
          child: Icon(
            Icons.email_outlined,
            size: 40,
            color: AppTheme.backgroundLight,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Check Your Email',
          style: AppStyles.custom(
            size: 32,
            weight: FontWeight.bold,
            color: AppTheme.backgroundLight,
            letterSpacing: -0.5,
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
                TextSpan(text: 'We\'ve sent a verification link to\n'),
                TextSpan(
                  text: email,
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildPrimaryButton(
          text: 'Open Email App',
          icon: Icons.mail_outline_rounded,
          onPressed: () {
            // Open email app logic here
          },
        ),
        const SizedBox(height: 16),
        _buildSecondaryButton(
          text: 'Resend Email',
          onPressed: () {
            // Resend email logic here
          },
        ),
        const SizedBox(height: 16),
        _buildSecondaryButton(
          text: 'Back to Login',
          onPressed: () => RouteService.backToLogin(),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
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
        color: AppTheme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppTheme.backgroundLight, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
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
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundLight.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: AppStyles.custom(
                color: AppTheme.backgroundLight,
                size: 16,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
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
              'Didn\'t receive the email? Check your spam folder or try resending.',
              style: AppStyles.custom(
                color: AppTheme.backgroundLight.withOpacity(0.8),
                size: 14,
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

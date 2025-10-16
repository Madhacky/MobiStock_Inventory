import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/auth%20controllers/auth_controller.dart';

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
          child: Obx(() => Column(
            children: [
              _buildHeader(controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: SlideTransition(
                      position: controller.slideAnimation,
                      child: _buildCurrentStep(controller, context),
                    ),
                  ),
                ),
              ),
              _buildNavigationButtons(controller, context),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildHeader(AuthController controller) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Register Your Shop',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s get your business online in just a few steps',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha:0.8),
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressIndicator(controller),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(AuthController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${controller.currentStep.value} of 5',
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.8),
                fontSize: 14,
              ),
            ),
            Text(
              '${(controller.currentStep.value * 20).toInt()}%',
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: controller.currentStep.value / 5.0,
          backgroundColor: Colors.white.withValues(alpha:0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(AuthController controller, BuildContext context) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildBasicInformation(controller);
      case 2:
        return _buildShopAddress(controller);
      case 3:
        return _buildSocialMediaLinks(controller);
      case 4:
        return _buildShopImages(controller);
      case 5:
        return _buildVerificationAndAgreement(controller);
      default:
        return _buildBasicInformation(controller);
    }
  }

  Widget _buildBasicInformation(AuthController controller) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Basic Information'),
          const SizedBox(height: 24),
          _buildModernTextField(
            controller: controller.shopStoreNameController,
            hintText: 'Shop Store Name',
            prefixIcon: Icons.store_mall_directory_outlined,
            validator: controller.validateShopStoreName,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.emailController,
            hintText: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
            isRequired: true,
          ),
          const SizedBox(height: 20),
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
                color: Colors.white.withValues(alpha:0.7),
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: controller.validatePassword,
            isRequired: true,
          )),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.gstNumberController,
            hintText: 'GST Number (Optional)',
            prefixIcon: Icons.receipt_long_outlined,
            validator: controller.validateGSTNumber,
            isRequired: false,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.adhaarNumberController,
            hintText: 'Aadhaar Number',
            prefixIcon: Icons.credit_card_outlined,
            keyboardType: TextInputType.number,
            validator: controller.validateAdhaarNumber,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildShopAddress(AuthController controller) {
    return Form(
      key: controller.addressFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Shop Address'),
          const SizedBox(height: 24),
           _buildModernTextField(
             controller: controller.contactPersonController,
             hintText: 'Contact Person Name',
             prefixIcon: Icons.person_outlined,
             validator: controller.validateContactPerson,
             isRequired: true,
           ),
     const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.phoneNumberController,
            hintText: 'Phone Number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhoneNumber,
            isRequired: true,
            
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.addressLine1Controller,
            hintText: 'Address Line 1',
            prefixIcon: Icons.home_outlined,
            validator: controller.validateAddressLine1,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.addressLine2Controller,
            hintText: 'Address Line 2',
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: 20),
          _buildModernTextField(
            controller: controller.landmarkController,
            hintText: 'Landmark',
            prefixIcon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: controller.cityController,
                  hintText: 'City',
                  prefixIcon: Icons.location_city_outlined,
                  validator: controller.validateCity,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: controller.stateController,
                  hintText: 'State',
                  prefixIcon: Icons.map_outlined,
                  validator: controller.validateState,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: controller.pincodeController,
                  hintText: 'Pincode',
                  prefixIcon: Icons.local_post_office_outlined,
                  keyboardType: TextInputType.number,
                  validator: controller.validatePincode,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: controller.countryController,
                  hintText: 'Country',
                  prefixIcon: Icons.public_outlined,
                  validator: controller.validateCountry,
                  isRequired: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaLinks(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Social Media Links (Optional)'),
        const SizedBox(height: 16),
        Text(
          'Connect your social media profiles to boost your online presence',
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        ...controller.socialMediaLinks.map((link) => 
          _buildSocialMediaInput(controller, link)
        ).toList(),
        const SizedBox(height: 16),
        _buildAddSocialMediaButton(controller),
      ],
    );
  }

  Widget _buildSocialMediaInput(AuthController controller, Map<String, dynamic> link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: link['platform'],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha:0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              dropdownColor: Color(0xFF374151),
              style: TextStyle(color: Colors.white),
              items: [
                DropdownMenuItem(value: 'facebook', child: Row(children: [Icon(Icons.facebook, color: Color(0xFF4267B2), size: 16), SizedBox(width: 8), Text('Facebook')])),
                DropdownMenuItem(value: 'instagram', child: Row(children: [Icon(Icons.camera_alt, color: Color(0xFFE4405F), size: 16), SizedBox(width: 8), Text('Instagram')])),
                DropdownMenuItem(value: 'twitter', child: Row(children: [Icon(Icons.alternate_email, color: Color(0xFF1DA1F2), size: 16), SizedBox(width: 8), Text('Twitter')])),
                DropdownMenuItem(value: 'linkedin', child: Row(children: [Icon(Icons.business, color: Color(0xFF0077B5), size: 16), SizedBox(width: 8), Text('LinkedIn')])),
                DropdownMenuItem(value: 'youtube', child: Row(children: [Icon(Icons.play_circle_fill, color: Color(0xFFFF0000), size: 16), SizedBox(width: 8), Text('YouTube')])),
              ],
              onChanged: (value) {
                link['platform'] = value;
                controller.socialMediaLinks.refresh();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: link['controller'],
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Profile URL',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.6)),
                filled: true,
                fillColor: Colors.white.withValues(alpha:0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => controller.removeSocialMediaLink(link),
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSocialMediaButton(AuthController controller) {
    return GestureDetector(
      onTap: controller.socialMediaLinks.length < 5 ? controller.addSocialMediaLink : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: controller.socialMediaLinks.length < 5 
            ? Color(0xFF4267B2)
            : Colors.grey.withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Add Social Link (${controller.socialMediaLinks.length}/5)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopImages(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Shop Image (Optional)'),
        const SizedBox(height: 16),
        Text(
          'Add one image of your shop to help customers recognize your business',
          style: TextStyle(
            color: Colors.white.withValues(alpha:0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => controller.shopImage.value == null
          ? GestureDetector(
              onTap: controller.addShopImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 64,
                      color: Colors.white.withValues(alpha:0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tap to add shop image',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _buildImagePreview(controller),
        ),
      ],
    );
  }

  Widget _buildImagePreview(AuthController controller) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha:0.3), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.shopImage.value!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.removeShopImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.addShopImage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF4267B2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Change',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationAndAgreement(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Review & Confirm'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha:0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildReviewItem('Shop Name:', controller.shopStoreNameController.text),
              _buildReviewItem('Email:', controller.emailController.text),
              _buildReviewItem('Phone:', controller.phoneNumberController.text),
              _buildReviewItem('Address:', '${controller.addressLine1Controller.text}, ${controller.cityController.text}'),
              if (controller.gstNumberController.text.isNotEmpty)
                _buildReviewItem('GST Number:', controller.gstNumberController.text),
              _buildReviewItem('Aadhaar Number:', controller.adhaarNumberController.text),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: controller.agreeToTerms.value 
                ? Colors.green.withValues(alpha:0.5)
                : Colors.white.withValues(alpha:0.2),
              width: 2,
            ),
          ),
          child: CheckboxListTile(
            value: controller.agreeToTerms.value,
            onChanged: (value) => controller.agreeToTerms.value = value ?? false,
            activeColor: Colors.white,
            checkColor: Color(0xFF667eea),
            title: RichText(
              text: TextSpan(
                text: 'I agree to the ',
                style: TextStyle(color: Colors.white.withValues(alpha:0.8)),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: Colors.white, 
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: Colors.white, 
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        )),
        const SizedBox(height: 12),
        Obx(() => CheckboxListTile(
          value: controller.subscribeToNewsletter.value,
          onChanged: (value) => controller.subscribeToNewsletter.value = value ?? false,
          activeColor: Colors.white,
          checkColor: Color(0xFF667eea),
          title: Text(
            'Subscribe to our newsletter for updates and tips',
            style: TextStyle(color: Colors.white.withValues(alpha:0.8)),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        )),
        const SizedBox(height: 16),
        if (!controller.agreeToTerms.value)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withValues(alpha:0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please agree to terms and conditions to complete registration',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
  bool isRequired = false,
}) {
  // Determine if this field is a phone number field
  final bool isPhoneField =
      keyboardType == TextInputType.phone || hintText.toLowerCase().contains('phone');

  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: isPhoneField
          ? [
              FilteringTextInputFormatter.digitsOnly, // only numbers
              LengthLimitingTextInputFormatter(10),   // max 10 digits
            ]
          : null,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText + (isRequired ? ' *' : ''),
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white.withValues(alpha: 0.7),
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


  Widget _buildNavigationButtons(AuthController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (controller.currentStep.value > 1)
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.white.withValues(alpha:0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Previous',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          if (controller.currentStep.value > 1) const SizedBox(width: 16),
          Expanded(
            child: Obx(() {
              bool isLastStep = controller.currentStep.value == 5;
              bool isButtonDisabled = isLastStep && !controller.agreeToTerms.value;
              
              return Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: isButtonDisabled
                    ? LinearGradient(
                        colors: [
                          Colors.grey.withValues(alpha:0.5),
                          Colors.grey.withValues(alpha:0.7),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFF8E8E),
                        ],
                      ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isButtonDisabled ? [] : [
                    BoxShadow(
                      color: Color(0xFFFF6B6B).withValues(alpha:0.3),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: (controller.isLoading.value || isButtonDisabled) ? null : () {
                      if (isLastStep) {
                        controller.signup(context);
                      } else {
                        controller.nextStep();
                      }
                    },
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isButtonDisabled)
                                Icon(Icons.lock, color: Colors.white, size: 20),
                              if (isButtonDisabled)
                                const SizedBox(width: 8),
                              Text(
                                isLastStep ? 'Complete \nRegistration' : 'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!isLastStep) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ],
                          ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
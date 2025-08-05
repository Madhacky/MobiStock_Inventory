import 'dart:io';
import 'package:flutter/material.dart';
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
            hintText: 'GST Number',
            prefixIcon: Icons.receipt_long_outlined,
            validator: controller.validateGSTNumber,
            isRequired: true,
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
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: controller.contactPersonController,
                  hintText: 'Contact Person Name',
                  prefixIcon: Icons.person_outlined,
                  validator: controller.validateContactPerson,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: controller.phoneNumberController,
                  hintText: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhoneNumber,
                  isRequired: true,
                ),
              ),
            ],
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
        _buildStepTitle('Social Media Links'),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF4267B2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Text(
              'Add Social Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
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
                DropdownMenuItem(value: 'Facebook', child: Row(children: [Icon(Icons.facebook, color: Color(0xFF4267B2), size: 16), SizedBox(width: 8), Text('Facebook')])),
                DropdownMenuItem(value: 'Instagram', child: Row(children: [Icon(Icons.camera_alt, color: Color(0xFFE4405F), size: 16), SizedBox(width: 8), Text('Instagram')])),
                DropdownMenuItem(value: 'Twitter', child: Row(children: [Icon(Icons.alternate_email, color: Color(0xFF1DA1F2), size: 16), SizedBox(width: 8), Text('Twitter')])),
                DropdownMenuItem(value: 'LinkedIn', child: Row(children: [Icon(Icons.business, color: Color(0xFF0077B5), size: 16), SizedBox(width: 8), Text('LinkedIn')])),
                DropdownMenuItem(value: 'YouTube', child: Row(children: [Icon(Icons.play_circle_fill, color: Color(0xFFFF0000), size: 16), SizedBox(width: 8), Text('YouTube')])),
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
      onTap: controller.addSocialMediaLink,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFF4267B2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Add Social Link',
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
        _buildStepTitle('Shop Images (Max 5)'),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: controller.addShopImage,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4267B2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: controller.shopImages.map((image) => 
            _buildImagePreview(controller, image)
          ).toList(),
        )),
      ],
    );
  }

  Widget _buildImagePreview(AuthController controller, File? image) {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha:0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white.withValues(alpha:0.6),
                    size: 40,
                  ),
          ),
          if (image != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => controller.removeShopImage(image),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
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
        _buildStepTitle('Verification & Agreement'),
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
              _buildReviewItem('Address:', '${controller.addressLine1Controller.text}, ${controller.cityController.text}'),
              _buildReviewItem('GST Number:', controller.gstNumberController.text),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Obx(() => CheckboxListTile(
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
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        )),
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
            width: 100,
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
              value,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.2),
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
          hintText: hintText + (isRequired ? ' *' : ''),
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha:0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white.withValues(alpha:0.7),
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          if (controller.currentStep.value > 1) const SizedBox(width: 16),
          Expanded(
            child: Obx(() => Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6B6B),
                    Color(0xFFFF8E8E),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
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
                  onTap: controller.isLoading.value ? null : () {
                    if (controller.currentStep.value == 5) {
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
                            Text(
                              controller.currentStep.value == 5 ? 'Complete Registration' : 'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (controller.currentStep.value < 5) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ],
                        ),
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
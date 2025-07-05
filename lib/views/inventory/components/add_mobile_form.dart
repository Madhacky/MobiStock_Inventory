import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_management_controller.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/image_uploader_widget.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class MobileInventoryForm extends StatelessWidget {
  const MobileInventoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final InventoryController controller = Get.find<InventoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.addMobileFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(controller),
              _buildFormContent(controller),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(InventoryController controller) {
    return AppBar(
      backgroundColor: AppTheme.backgroundLight,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: customBackButton(isdark: true),
      ),
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 45.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_box, color: AppTheme.backgroundLight, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADD NEW MOBILE',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                   Text(
                    'Fill details to add inventory',
                    style: AppStyles.custom(
                      color: Color(0xFF6B7280),
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader(InventoryController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          color: AppTheme.backgroundLight,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: controller
                      .getCompanyColor(
                        controller.selectedAddCompany.value.isEmpty
                            ? null
                            : controller.selectedAddCompany.value,
                      )
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller
                        .getCompanyColor(
                          controller.selectedAddCompany.value.isEmpty
                              ? null
                              : controller.selectedAddCompany.value,
                        )
                        .withOpacity(0.2),
                  ),
                ),
                child: Icon(
                  Icons.phone_android,
                  color: controller.getCompanyColor(
                    controller.selectedAddCompany.value.isEmpty
                        ? null
                        : controller.selectedAddCompany.value,
                  ),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.formattedDeviceName,
                      style:  AppStyles.custom(
                        color: Color(0xFF1A1A1A),
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.formattedDeviceSpecs,
                      style:  AppStyles.custom(
                        color: Color(0xFF6B7280),
                        size: 12,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.selectedAddColor.value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: controller
                        .getCompanyColor(
                          controller.selectedAddCompany.value.isEmpty
                              ? null
                              : controller.selectedAddCompany.value,
                        )
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    controller.selectedAddColor.value,
                    style: AppStyles.custom(
                      color: controller.getCompanyColor(
                        controller.selectedAddCompany.value.isEmpty
                            ? null
                            : controller.selectedAddCompany.value,
                      ),
                      size: 12,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(InventoryController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Device Information', Icons.phone_android),
            const SizedBox(height: 16),

            // Company Dropdown
            Obx(
              () => buildStyledDropdown(
                labelText: 'Company',
                hintText: 'Select Company',
                value:
                    controller.selectedAddCompany.value.isEmpty
                        ? null
                        : controller.selectedAddCompany.value,
                items: controller.companies,
                onChanged:
                    (value) => controller.onAddCompanyChanged(value ?? ''),
                validator: controller.validateCompany,
              ),
            ),
            const SizedBox(height: 16),

            // Model Dropdown
            Obx(
              () => buildStyledDropdown(
                labelText: 'Model',
                hintText:
                    !controller.isModelSelectionEnabled
                        ? 'Please select a company first'
                        : 'Select Model',
                value:
                    controller.selectedAddModel.value.isEmpty
                        ? null
                        : controller.selectedAddModel.value,
                enabled: controller.isModelSelectionEnabled,
                items: controller.getModelsForCompany(
                  controller.selectedAddCompany.value,
                ),
                onChanged: (value) => controller.onAddModelChanged(value ?? ''),
                validator: controller.validateModel,
              ),
            ),
            const SizedBox(height: 16),

            // RAM and Storage Row
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => buildStyledDropdown(
                      labelText: 'RAM',
                      hintText: 'Select RAM',
                      value:
                          controller.selectedAddRam.value.isEmpty
                              ? null
                              : controller.selectedAddRam.value,
                      items: controller.ramOptions,
                      onChanged:
                          (value) => controller.onAddRamChanged(value ?? ''),
                      validator: controller.validateRam,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => buildStyledDropdown(
                      labelText: 'Storage (ROM)',
                      hintText: 'Select Storage',
                      value:
                          controller.selectedAddStorage.value.isEmpty
                              ? null
                              : controller.selectedAddStorage.value,
                      items: controller.storageOptions,
                      onChanged:
                          (value) =>
                              controller.onAddStorageChanged(value ?? ''),
                      validator: controller.validateStorage,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Color Dropdown
            Obx(
              () => buildStyledDropdown(
                labelText: 'Color',
                hintText: 'Select Color',
                value:
                    controller.selectedAddColor.value.isEmpty
                        ? null
                        : controller.selectedAddColor.value,
                items: controller.colorOptions,
                onChanged: (value) => controller.onAddColorChanged(value ?? ''),
                validator: controller.validateColor,
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Pricing & Stock', Icons.inventory),
            const SizedBox(height: 16),

            // Price and Quantity Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Selling Price',
                    controller: controller.priceController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    validator: controller.validatePrice,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Quantity',
                    controller: controller.quantityController,
                    hintText: '0',
                    suffixText: 'units',
                    keyboardType: TextInputType.number,
                    validator: controller.validateQuantity,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Product Image', Icons.image),
            const SizedBox(height: 16),

            // Image Upload
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.greyOpacity05,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.greyOpacity01),
              ),
              child: ImageUploadWidget(
                labelText: 'Mobile Logo/Image',
                uploadText: 'Upload Image',
                onImageSelected: controller.onImageSelected,
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: OutlinedButton(
                        onPressed:
                            controller.isAddingMobile.value
                                ? null
                                : controller.cancelAddMobile,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.greyOpacity03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:  Text(
                          'Cancel',
                          style: AppStyles.custom(
                            color: Color(0xFF6B7280),
                            size: 12,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            controller.isAddingMobile.value
                                ? null
                                : controller.addMobileToInventory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            controller.isAddingMobile.value
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.backgroundLight,
                                    ),
                                  ),
                                )
                                :  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppTheme.backgroundLight,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Add to Inventory',
                                      style: AppStyles.custom(
                                        color: AppTheme.backgroundLight,
                                        size: 12,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Error Message Display
            Obx(
              () =>
                  controller.hasAddMobileError.value
                      ? Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.redOpacity01,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.redOpacity03,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppTheme.primaryRed,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.addMobileErrorMessage.value,
                                style:  AppStyles.custom(
                                  color: AppTheme.primaryRed,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppStyles.custom(
            color: Color(0xFF1A1A1A),
            size: 16,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

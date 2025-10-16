import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smartbecho/controllers/inventory%20controllers/Inventory_crud_operation_controller.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/image_uploader_widget.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/app_styles.dart';

class AddNewMobileInventoryForm extends StatelessWidget {
  const AddNewMobileInventoryForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InventoryCrudOperationController controller =
        Get.find<InventoryCrudOperationController>();

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

  PreferredSizeWidget _buildAppBar(
    InventoryCrudOperationController controller,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
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
              child: const Icon(Icons.add_box, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADD ONLINE PRODUCT',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Fill details to add inventory',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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

  Widget _buildFormHeader(InventoryCrudOperationController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          color: Colors.white,
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
                            ? controller.companyTextController.text.isEmpty
                                ? null
                                : controller.companyTextController.text
                            : controller.selectedAddCompany.value,
                      )
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller
                        .getCompanyColor(
                          controller.selectedAddCompany.value.isEmpty
                              ? controller.companyTextController.text.isEmpty
                                  ? null
                                  : controller.companyTextController.text
                              : controller.selectedAddCompany.value,
                        )
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.phone_android,
                  color: controller.getCompanyColor(
                    controller.selectedAddCompany.value.isEmpty
                        ? controller.companyTextController.text.isEmpty
                            ? null
                            : controller.companyTextController.text
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
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.formattedDeviceSpecs,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
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
                              ? controller.companyTextController.text.isEmpty
                                  ? null
                                  : controller.companyTextController.text
                              : controller.selectedAddCompany.value,
                        )
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    controller.selectedAddColor.value,
                    style: TextStyle(
                      color: controller.getCompanyColor(
                        controller.selectedAddCompany.value.isEmpty
                            ? controller.companyTextController.text.isEmpty
                                ? null
                                : controller.companyTextController.text
                            : controller.selectedAddCompany.value,
                      ),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(InventoryCrudOperationController controller) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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

            // Category Dropdown - NEW
            Obx(() {
              if (controller.isLoadingCategories.value) {
                return buildShimmerTextField();
              }

              return buildStyledDropdown(
                labelText: 'Category',
                hintText: 'Select Category',
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                items: controller.categories,
                onChanged: (value) => controller.onCategoryChanged(value ?? ''),
                validator: controller.validateCategory,
              );
            }),
            const SizedBox(height: 16),

            // Company Field
            Obx(() {
              if (controller.isLoadingFilters.value) {
                return buildShimmerTextField();
              }

              if (controller.isCompanyTypeable.value) {
                return buildStyledTextField(
                  labelText: 'Company',
                  controller: controller.companyTextController,
                  hintText: 'Enter company name',
                  validator: controller.validateCompany,
                  onChanged: controller.onCompanyTextChanged,
                );
              } else {
                return buildStyledDropdown(
                  labelText: 'Company',
                  hintText: 'Select Company',
                  value: controller.selectedAddCompany.value.isEmpty
                      ? null
                      : controller.selectedAddCompany.value,
                  items: controller.companies,
                  onChanged: (value) => controller.onAddCompanyChanged(value ?? ''),
                  validator: controller.validateCompany,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () {
                      controller.isCompanyTypeable.value = true;
                      controller.companyTextController.text =
                          controller.selectedAddCompany.value;
                    },
                    tooltip: 'Type custom company',
                  ),
                );
              }
            }),
            const SizedBox(height: 16),

            // Model Field
            Obx(() {
              if (controller.isLoadingModels.value) {
                return buildShimmerTextField();
              }

              bool isEnabled = controller.isModelSelectionEnabled;

              if (!isEnabled) {
                return buildStyledDropdown(
                  labelText: 'Model',
                  hintText: 'Please select a company first',
                  value: null,
                  enabled: false,
                  items: const [],
                  onChanged: (p0) {},
                  validator: controller.validateModel,
                );
              }

              if (controller.isModelTypeable.value) {
                return buildStyledTextField(
                  labelText: 'Model',
                  controller: controller.modelTextController,
                  hintText: 'Enter model name',
                  validator: controller.validateModel,
                  onChanged: controller.onModelTextChanged,
                );
              } else {
                return buildStyledDropdown(
                  labelText: 'Model',
                  hintText: 'Select Model',
                  value: controller.selectedAddModel.value.isEmpty
                      ? null
                      : controller.selectedAddModel.value,
                  items: controller.models,
                  onChanged: (value) => controller.onAddModelChanged(value ?? ''),
                  validator: controller.validateModel,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () {
                      controller.isModelTypeable.value = true;
                      controller.modelTextController.text =
                          controller.selectedAddModel.value;
                    },
                    tooltip: 'Type custom model',
                  ),
                );
              }
            }),

            // RAM and Storage Row - CONDITIONAL
            Obx(() {
              if (controller.shouldShowRamRom) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: buildStyledDropdown(
                            labelText: 'RAM (GB)',
                            hintText: 'Select RAM',
                            value: controller.selectedAddRam.value.isEmpty
                                ? null
                                : controller.selectedAddRam.value,
                            items: controller.ramOptions,
                            enabled: true,
                            onChanged: (value) => controller.onAddRamChanged(value ?? ''),
                            validator: controller.validateRam,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildStyledDropdown(
                            labelText: 'Storage (ROM) (GB)',
                            hintText: 'Select Storage',
                            value: controller.selectedAddStorage.value.isEmpty
                                ? null
                                : controller.selectedAddStorage.value,
                            items: controller.storageOptions,
                            enabled: true,
                            onChanged: (value) => controller.onAddStorageChanged(value ?? ''),
                            validator: controller.validateStorage,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 16),

            // Color Dropdown
            Obx(() {
              if (controller.isColorTypeable.value) {
                return buildStyledTextField(
                  labelText: 'Color',
                  controller: controller.colorTextController,
                  hintText: 'Enter color',
                  validator: controller.validateColor,
                  onChanged: controller.onColorTextChanged,
                );
              } else {
                return buildStyledDropdown(
                  labelText: 'Color',
                  hintText: 'Select Color',
                  value: controller.selectedAddColor.value.isEmpty
                      ? null
                      : controller.selectedAddColor.value,
                  items: controller.colorOptions,
                  onChanged: (value) => controller.onAddColorChanged(value ?? ''),
                  validator: controller.validateColor,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () {
                      controller.isColorTypeable.value = true;
                      controller.colorTextController.text =
                          controller.selectedAddColor.value;
                    },
                    tooltip: 'Type custom color',
                  ),
                );
              }
            }),

            const SizedBox(height: 24),
            _buildSectionTitle('Product Description', Icons.description),
            const SizedBox(height: 16),

            // Product Description - REQUIRED
            buildStyledTextField(
              labelText: 'Product Description',
              controller: controller.descriptionController,
              hintText: 'Enter product description',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              validator: controller.validateDescription,
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
            _buildSectionTitle('Purchase Information', Icons.shopping_bag),
            const SizedBox(height: 16),

            // Purchased From - REQUIRED
            buildStyledTextField(
              labelText: 'Purchased From',
              controller: controller.purchasedFromController,
              hintText: 'e.g., Amazon, Flipkart, Local Store',
              keyboardType: TextInputType.text,
              validator: controller.validatePurchasedFrom,
            ),
            const SizedBox(height: 16),

            // Purchase Date - REQUIRED
            Obx(() => InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: Get.context!,
                  initialDate: controller.selectedPurchaseDate.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF6366F1),
                          onPrimary: Colors.white,
                          onSurface: Color(0xFF1A1A1A),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  controller.onPurchaseDateChanged(picked);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Purchase Date',
                    style: TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6B7280)),
                        const SizedBox(width: 12),
                        Text(
                          controller.selectedPurchaseDate.value != null
                              ? controller.formatDateForApi(controller.selectedPurchaseDate.value!)
                              : 'Select purchase date',
                          style: TextStyle(
                            color: controller.selectedPurchaseDate.value != null
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),

            // Purchase Notes - OPTIONAL
            buildStyledTextField(
              labelText: 'Purchase Notes (optional)',
              controller: controller.purchaseNotesController,
              hintText: 'Any additional notes about the purchase',
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Product Image', Icons.image),
            const SizedBox(height: 16),

            // Image Upload
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: ImageUploadWidget(
                labelText: 'Product Logo/Image',
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
                        onPressed: controller.isAddingMobile.value
                            ? null
                            : controller.cancelAddMobile,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isAddingMobile.value
                            ? null
                            : controller.addMobileToInventory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isAddingMobile.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Add to Inventory',
                                    style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.fade,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
              () => controller.hasAddMobileError.value
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.addMobileErrorMessage.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
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
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildShimmerTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 14,
            width: 100,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 6),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/add_new_stock_operation_controller.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_textfield.dart';
import 'package:smartbecho/utils/custom_back_button.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';

class AddNewStockForm extends StatelessWidget {
  const AddNewStockForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddNewStockOperationController controller = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: Form(
        key: controller.addBillFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildFormContent(controller)],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AddNewStockOperationController controller) {
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
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADD NEW STOCK',
                    style: AppStyles.custom(
                      color: const Color(0xFF1A1A1A),
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Create a new billing entry',
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

  Widget _buildFormContent(AddNewStockOperationController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
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
            _buildSectionTitle('Bill Information', Icons.receipt),
            const SizedBox(height: 16),

            // Company Name
            buildStyledTextField(
              labelText: 'Company Name',
              controller: controller.companyNameController,
              hintText: 'Enter company name',
              validator: controller.validateCompanyName,
            ),
            const SizedBox(height: 16),

            // Payment Status
            _buildPaymentStatusToggle(controller),
            const SizedBox(height: 16),

            // GST and Without GST Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'GST (%)',
                    controller: controller.gstController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: controller.validateGst,
                    onChanged: (value) {
                      controller.calculateTotals();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Without GST',
                    controller: controller.withoutGstController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    //  readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total Amount and Dues
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Total Amount',
                    controller: controller.amountController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    validator: controller.validateAmount,
                    // readOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'Dues',
                    controller: controller.duesController,
                    hintText: '0.00',
                    prefixText: '₹ ',
                    keyboardType: TextInputType.number,
                    //  readOnly: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Items', Icons.inventory_2),
            const SizedBox(height: 16),

            // Items List
            Obx(
              () => Column(
                children: [
                  ...controller.billItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    BillItem item = entry.value;
                    return _buildItemCard(controller, item, index);
                  }).toList(),

                  // Add Item Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.only(top: 12),
                    child: OutlinedButton.icon(
                      onPressed: controller.addNewItem,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Item'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF10B981).withValues(alpha:0.3),
                        ),
                        foregroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Invoice File', Icons.attach_file),
            const SizedBox(height: 16),

            // File Upload Section
            _buildFileUploadSection(controller),

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
                            controller.isAddingBill.value
                                ? null
                                : controller.cancelAddBill,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.withValues(alpha:0.3)),
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            controller.isAddingBill.value
                                ? null
                                : controller.addBillToSystem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            controller.isAddingBill.value
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
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Create Bill',
                                      style: TextStyle(
                                        color: Colors.white,
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
              () =>
                  controller.hasAddBillError.value
                      ? Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withValues(alpha:0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.addBillErrorMessage.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF10B981)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusToggle(AddNewStockOperationController controller) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Status',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.isPaid.value = true;
                      controller.calculateTotals();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            controller.isPaid.value
                                ? const Color(0xFF10B981)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Paid',
                          style: TextStyle(
                            color:
                                controller.isPaid.value
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.isPaid.value = false;
                      controller.calculateTotals();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            !controller.isPaid.value
                                ? const Color(0xFFEF4444)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Unpaid',
                          style: TextStyle(
                            color:
                                !controller.isPaid.value
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildItemCard(
  AddNewStockOperationController controller,
  BillItem item,
  int index,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.withValues(alpha:0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item header with remove button
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Item #${index + 1}',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => controller.removeItem(index),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Category Dropdown
        Obx(
          () => buildStyledDropdown(
            labelText: 'Category',
            hintText: 'Select Category',
            value: item.category.value.isEmpty ? null : item.category.value,
            items: controller.categories,
            onChanged: (String? newValue) {
              controller.updateItemField(index, 'category', newValue ?? '');
            },
          ),
        ),
        const SizedBox(height: 16),

        // Company and Model Row
        Row(
          children: [
            Expanded(
              child: Obx(
                () => buildStyledDropdown(
                  labelText: 'Company',
                  hintText: 'Select Company',
                  value: item.company.value.isEmpty ? null : item.company.value,
                  items: controller.companies,
                  onChanged: (String? newValue) {
                    controller.updateItemField(index, 'company', newValue ?? '');
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => buildStyledDropdown(
                  labelText: 'Model',
                  hintText: 'Select Model',
                  value: item.model.value.isEmpty ? null : item.model.value,
                  items: controller.models,
                  onChanged: (String? newValue) {
                    controller.updateItemField(index, 'model', newValue ?? '');
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Show RAM and ROM only for SMARTPHONE category
        Obx(
          () => item.category.value == 'SMARTPHONE' || item.category.value == 'TABLET'
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildStyledDropdown(
                            labelText: 'RAM (GB)',
                            hintText: 'Select RAM',
                            value: item.ram.value.isEmpty ? null : item.ram.value,
                            items: controller.ramOptions,
                            onChanged: (String? newValue) {
                              controller.updateItemField(index, 'ram', newValue ?? '');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildStyledDropdown(
                            labelText: 'ROM (GB)',
                            hintText: 'Select ROM',
                            value: item.rom.value.isEmpty ? null : item.rom.value,
                            items: controller.storageOptions,
                            onChanged: (String? newValue) {
                              controller.updateItemField(index, 'rom', newValue ?? '');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        // Color and Quantity Row
        Row(
          children: [
            Expanded(
              child: Obx(
                () => buildStyledDropdown(
                  labelText: 'Color',
                  hintText: 'Select Color',
                  value: item.color.value.isEmpty ? null : item.color.value,
                  items: controller.colorOptions,
                  onChanged: (String? newValue) {
                    controller.updateItemField(index, 'color', newValue ?? '');
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildStyledTextField(
                labelText: 'Quantity',
                controller: item.qtyController,
                hintText: '1',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.updateItemField(index, 'qty', value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Selling Price
        buildStyledTextField(
          labelText: 'Selling Price',
          controller: item.priceController,
          hintText: '0',
          prefixText: '₹ ',
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.updateItemField(index, 'sellingPrice', value);
          },
        ),
        const SizedBox(height: 16),

        // Description
        buildStyledTextField(
          labelText: 'Description (Optional)',
          controller: item.descriptionController,
          hintText: 'Enter item description',
          maxLines: 3,
          onChanged: (value) {
            controller.updateItemField(index, 'description', value);
          },
        ),
      ],
    ),
  );
}


  Widget _buildFileUploadSection(AddNewStockOperationController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha:0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha:0.2),
            style: BorderStyle.solid,
          ),
        ),
        child:
            controller.selectedFile.value != null
                ? _buildSelectedFileCard(controller)
                : _buildFilePickerButton(controller),
      ),
    );
  }

  Widget _buildFilePickerButton(AddNewStockOperationController controller) {
    return Obx(
      () => InkWell(
        onTap: controller.isFileUploading.value ? null : controller.pickFile,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isFileUploading.value)
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                )
              else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.cloud_upload_rounded,
                    color: Color(0xFF10B981),
                    size: 24,
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                controller.isFileUploading.value
                    ? 'Selecting file...'
                    : 'Upload Invoice',
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.isFileUploading.value
                    ? 'Please wait'
                    : 'Click to select JPG, PNG, or PDF file',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFileCard(AddNewStockOperationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(controller.fileName.value),
              color: const Color(0xFF10B981),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.fileName.value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'File selected successfully',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: controller.removeFile,
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    String extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.attach_file;
    }
  }
}

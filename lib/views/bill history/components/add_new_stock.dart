import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD:lib/views/bill history/components/add_bill.dart
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_operation_controller.dart';
import 'package:smartbecho/utils/app_colors.dart';
=======
import 'package:smartbecho/controllers/bill%20history%20controllers/add_new_stock_operation_controller.dart';
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628:lib/views/bill history/components/add_new_stock.dart
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
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppTheme.backgroundLight,
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
                  Text(
                    'Create a new billing entry',
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

  Widget _buildFormContent(AddNewStockOperationController controller) {
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

            // GST and Amount Row
            Row(
              children: [
                Expanded(
                  child: buildStyledTextField(
                    labelText: 'GST',
                    controller: controller.gstController,
                    hintText: '0.00',
                    //suffixText: '%',
                    keyboardType: TextInputType.number,
                    validator: controller.validateGst,
                    // onChanged: (value) {
                    //   controller.calculateTotals();
                    // },
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
                //    readOnly: true,
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
                    // readOnly: true,
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
                          color: const Color(0xFF10B981).withOpacity(0.3),
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
                          side: BorderSide(color: AppTheme.greyOpacity03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
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
                                      AppTheme.backgroundLight,
                                    ),
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: AppTheme.backgroundLight,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Create Bill',
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
                  controller.hasAddBillError.value
                      ? Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.primaryRed.withOpacity(0.3),
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
                                controller.addBillErrorMessage.value,
                                style: AppStyles.custom(
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

  Widget _buildFileUploadSection(AddNewStockOperationController controller) {
    return Obx(() => Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: controller.selectedFile.value != null
          ? _buildSelectedFileCard(controller)
          : _buildFilePickerButton(controller),
    ));
  }

  Widget _buildFilePickerButton(AddNewStockOperationController controller) {
    return Obx(() => InkWell(
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
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
    ));
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
              color: const Color(0xFF10B981).withOpacity(0.1),
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
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'File selected successfully',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              // Change file button
              InkWell(
                onTap: controller.pickFile,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Remove file button
              InkWell(
                onTap: controller.removeFile,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ),
            ],
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

  Widget _buildPaymentStatusToggle(AddNewStockOperationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Status',
          style: AppStyles.custom(
            color: Color(0xFF374151),
            size: 13,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.isPaid.value = true;
                    controller.calculateTotals();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          controller.isPaid.value
                              ? const Color(0xFF10B981)
                              : AppTheme.greyOpacity01,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            controller.isPaid.value
                                ? const Color(0xFF10B981)
                                : AppTheme.greyOpacity03,
                      ),
                    ),
                    child: Text(
                      'Paid',
                      textAlign: TextAlign.center,
                      style: AppStyles.custom(
                        color:
                            controller.isPaid.value
                                ? AppTheme.backgroundLight
                                : const Color(0xFF6B7280),
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.isPaid.value = false;
                    controller.calculateTotals();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          !controller.isPaid.value
                              ? const Color(0xFFEF4444)
                              : AppTheme.greyOpacity01,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            !controller.isPaid.value
                                ? const Color(0xFFEF4444)
                                : AppTheme.greyOpacity03,
                      ),
                    ),
                    child: Text(
                      'Unpaid',
                      textAlign: TextAlign.center,
                      style: AppStyles.custom(
                        color:
                            !controller.isPaid.value
                                ? AppTheme.backgroundLight
                                : const Color(0xFF6B7280),
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD:lib/views/bill history/components/add_bill.dart
  Widget _buildItemCard(
    BillOperationController controller,
    BillItem item,
    int index,
  ) {
=======
  Widget _buildItemCard(AddNewStockOperationController controller, BillItem item, int index) {
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628:lib/views/bill history/components/add_new_stock.dart
    // Set initial values for controllers if they are empty
    if (item.priceController.text.isEmpty && item.sellingPrice.isNotEmpty) {
      item.priceController.text = item.sellingPrice;
    }
    if (item.qtyController.text.isEmpty && item.qty.isNotEmpty) {
      item.qtyController.text = item.qty;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.greyOpacity05,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.greyOpacity01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: AppStyles.custom(
                  color: Color(0xFF374151),
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => controller.removeItem(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.primaryRed,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Company and Model
          Row(
            children: [
              Expanded(
                child: buildStyledDropdown(
                  labelText: 'Company',
                  hintText: 'Select Company',
                  value: item.company.isEmpty ? null : item.company,
                  items: controller.companies,
                  onChanged: (value) {
                    controller.updateItemField(index, 'company', value ?? '');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildStyledDropdown(
                  labelText: 'Model',
                  hintText: 'Select Model',
                  value: item.model.isEmpty ? null : item.model,
                  items: controller.models,
                  onChanged: (value) {
                    controller.updateItemField(index, 'model', value ?? '');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // RAM and Storage
          Row(
            children: [
              Expanded(
                child: buildStyledDropdown(
                  labelText: 'RAM (GB)',
                  hintText: 'Select RAM',
                  value: item.ram.isEmpty ? null : item.ram,
                  items: controller.ramOptions,
                  onChanged: (value) {
                    controller.updateItemField(index, 'ram', value ?? '');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildStyledDropdown(
                  labelText: 'Storage (GB)',
                  hintText: 'Select Storage',
                  value: item.rom.isEmpty ? null : item.rom,
                  items: controller.storageOptions,
                  onChanged: (value) {
                    controller.updateItemField(index, 'rom', value ?? '');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Color, Price and Quantity
          Row(
            children: [
              Expanded(
                child: buildStyledDropdown(
                  labelText: 'Color',
                  hintText: 'Select Color',
                  value: item.color.isEmpty ? null : item.color,
                  items: controller.colorOptions,
                  onChanged: (value) {
                    controller.updateItemField(index, 'color', value ?? '');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Price',
                  controller: item.priceController,
                  hintText: '0',
                  prefixText: '₹ ',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.updateItemField(index, 'sellingPrice', value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: buildStyledTextField(
                  labelText: 'Qty',
                  controller: item.qtyController,
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.updateItemField(index, 'qty', value);
                  },
                ),
              ),
            ],
          ),
        ],
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
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF10B981), size: 16),
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
